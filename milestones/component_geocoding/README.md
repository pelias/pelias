# Component Geocoding

We need the ability to geocode an input by its constituent parts when supplied by a user.  That is, instead of geocoding `30 West 26th Street, New York, NY`, we can additionally support geocoding using pre-parsed inputs from a client:

```
{
  address: '30 West 26th Street',
  city: 'New York',
  state: 'NY'
}
```

## Advantages

Currently we only support geocoding a single text input even for users that have addresses separated into components.  Users get around this limitation by concatenating the components together.  This is problematic because it forces us to needlessly parse an error-prone input.  

## Use Cases

The product owner or UI engineer for a project looking to use a geocoder may have determined that a componentized address input may be in the best interest of an application, for example when prompting for a shipping address where there is little room for error.  

Another example would be when a user is attempting to geocode a spreadsheet of collected componentized addresses.  

More generally, it may be beyond the technical abilities of a geocoding customer to concatenate the address components together or to even do it correctly.  

Regardless of specific use cases, it behooves us to implement a geocoding solution that can consider the components of an address.  

## Endpoint

Since componentized geocoding can be considered a subclass of single-input geocoding, we can probably just extend `/v1/search` into `/v1/search/component` or `/v1/nbox`.  The actual endpoint name is open to debate.  

## Parameters

The components we should support are:

* address
* neighbourhood
* borough
* locality
* county
* region
* country
* postalcode

A single parameter should be considered sufficient to geocode.  

### Querying Elasticsearch

Forcing clients to understand the intricacies our the administrative structure of WOF or our internal schema is not a good idea, so the parameters should map to our internal fields in this fashion:

| Parameter | Index Fields | Notes |
| --- | --- | --- |
| address | address | |
| borough | borough, borough_a | only applies to New York City |
| locality | locality, locality_a, localadmin, localadmin_a | Equivalent to city |
| county | county, county_a, macrocounty, macrocounty_a | |
| region | region, region_a, macroregion, macroregion_a | Equivalent to state |
| country | dependency, dependency_a, country, country_a | |
| postalcode | postalcode | |

Component geocoding should adopt the fallback behavior introduced in the libpostal integration.  That is, if the input `locality=Seattle&region=Pennsylvania` is supplied, then the state match for Pennsylvania should be returned since there is no city in Pennsylvania named Seattle.  

#### Edge Cases

We should steer clear of trying to impose additional interpretation upon the values supplied in the request.  One notable exception may be how `locality` is interpreted with respect to New York City boroughs.  Special consideration should be made for inputs that may have Manhattan supplied in the `locality` parameter.  If `borough` parameter is not supplied but `locality` is, then the `locality` value should be treated as if it could be a borough.  

Alternately, we could opt to simply not support a `borough` parameter, moving that decision into the client logic which means that we would just always consider `borough` values when querying for the `locality` value.  Since boroughs only affects a very smaller portion of the world (localized entirely to New York City), this may be the best option.  

### Valid Values

Only non-blank string parameters should be considered valid, otherwise values are discarded.  That is, if the request contains `locality= \t `, then the request should be treated as though no `locality` parameter was passed.  

Innocuous corrections such as space-trimming and -normalizing should be applied to inputs.  These corrections aren't a concern of single-input geocoding since libpostal already does this.  

### Error conditions

An error should be returned to the client if no parameters have valid values.  

## Other Geocoders

The question has been asked whether to support house number and street as separate fields or should we only support a single `address` field with those two values combined.  The other geocoders.  

### Carto

Carto's geocoder only exposes an `address` parameter, with no ability to supply separate house number and street parameters.  

### MapQuest

MapQuest does not support separate house number and street parameters, only a single `address` parameter.  To the best of my recollection, there were occasional requests to support separated fields but it was never a big enough concern to dedicate resources to it.  

### Geocod.io

Geocod.io only exposes a `street` parameter, no consideration is given to separated fields.

### Enigma

Enigma’s tiger geocoder appears to only expose a single input field for the entire address with all fields concatenated.  

## Future Work

### Spelling Correction

While it's a wise idea to support spelling correction anyway, this is an easier place to introduce it since there's no parsing service to misidentify tokens, i.e. - the client has already identified a particular input as a locality so we can more easily constrain spelling correction logic.  
