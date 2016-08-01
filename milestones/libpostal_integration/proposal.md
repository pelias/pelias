# Libpostal Integration

The libpostal integration is not just replacing addressit with libpostal for 1-box text analysis, it changes the way we do searches.  Until now, we’ve not been operating as a geocoder but more as search engine of terms that just so happen to be geo-related.  These changes were technically possible while still using addressit but it’s response was difficult to parse in a reliable way so it didn’t make sense to jump thru hoops to make it work.  With libpostal, we can now more confidently identify the parts of the input and make decisions about how elasticsearch should be searched to make Pelias behave more like a geocoder.  

This document describes the concepts of how to query ES, the affected pieces of the pelias architecture, and future work.  

## Queries

I started 2 new Query modules in the query package to handle the (so far) 2 different strategies for dealing with analyzed text.  There will most certainly be refinements to these queries and/or new queries added.  I would prefer to keep distinct behaviors as separate modules rather than build one monolithic Query module to rule all the things.  

### Fallback Query

**tl;dr - fallback to less granular administrative areas when inputs don't match**

When a user enters a single piece of text that contains a hierarchy of data, we can’t be confident that what the user entered is spelled correctly or even makes sense.  Ideally the user isn’t a drunken narcoleptic, for example:

`30 West 26th Street, New York, NY`

We look at the input and know that it makes sense.  libpostal parses this input as:

```
{
  "house_number": "30",
  "road": "west 26th street",
  "city": "new york",
  "state": "ny"
}
```

Searching ES for this analyzed input returns a single result (ideally, OA and OSM may have the same record).  However, a user could also input:

`1220 Calle De Lago, Seattle, Minnesota, France`

libpostal dutifully parses this as:

```
{
  "house_number": "1220",
  "road": "calle de lago",
  "city": "seattle",
  "state": "minnesota”,
  "country": "france"
}
```

In this example, none of the house_number+road, city, state, and country match.  While technically this is a correct parsing, there is no address 1220 Calle de Lago in Seattle, nor is there a Seattle in Minnesota, and lastly there is no state or region of France called Minnesota.  Nevertheless, this is what the user entered so we must try to make some sense of it.  I covered a lot of this in https://mapzen.com/blog/geocoding-places/.  

In this last example, the idea is to query for everything returned by libpostal:  house number, street, city, state, and country.  Because that combination may not have a match, simultaneously query for all the fields except the most granular:  city, state, and country.  You can probably see where this is going but because the city, state, and country combination may not be valid, also query ES for state and country and finally just country.  In this particular case, none of the combinations make sense so only the query for France would return anything.  

In the ideal case where all the fields combined make sense, as in `30 West 26th Street, New York, NY`, there be an address result, a city result, and a state result.  The API can later make decisions on which results to keep.  

This is the essence of the fallback query:  find the different combinations of analyzed text parts that make sense (not literally all combinations).  

The introduction of query and category terms complicate this a bit, as in the example `pizza 30 west 26th street, new york, ny`.  Until we have a 2-stage ES query that would first resolve the location terms then search for the query terms in the context of the geocoded location terms, the fallback query will first attempt to search for pizza in New York, NY then have all the other fallbacks in place in case the query+non-street location terms fails.  

- pizza in New York, NY
- 30 West 26th Street, New York, NY
- New York, NY
- NY

We have to search for pizza in New York, NY excluding the house number + street because if those terms were included then we would be searching for pizza venues that are only at 30 West 26th Street in New York, NY (there aren’t any until Randy convinces SRA to start one).  If there are no venues containing the word “pizza”, then the search would fallback to searching for the address and then to higher administrative areas.  

### Geodisambiguation Queries

**tl;dr - libpostal only returns 1 interpretation so we have to compensate**

One limitation of libpostal is that it returns a single result for any input.  I’ve talked about this before but Luxembourg isn’t just the name of a country, it’s also the name of a region in both Luxembourg and Belgium, and also the name of a locality in Luxembourg.  Here’s what libpostal does with Luxembourg:

```
> luxembourg

Result:

{
  "country": "luxembourg"
}
```

libpostal returns just a single interpretation of the term Luxembourg, so it’s up to us to compensate.  

In the case where libpostal returns just a single administrative area field and no other fields, the GeodisambiguationQuery is used to query across all supported administrative area fields.  For Luxembourg, the GeodisambiguationQuery queries ES at the following layers:

- neighborhood
- borough
- locality
- localadmin
- county
- macrocounty
- region
- macroregion
- country

This is needed because there’s no way to know which layers will be a match. 

Some other examples are Lancaster (a locality and county in Pennsylvania) and Ontario (a city in California and a region of Canada).  

The GeodisambiguationQuery allows us to compensate for libpostal single result limitation by querying across multiple fields at once.  


## Projects Effected

So far, the libpostal integration has affected the following packages:

- text-analyzer
- query
- api

All of these project modifications have been made with incremental updates in mind.  That is, text-analyzer and query changes were made to not require API updates for merge to master.  

### The text-analyzer project

The text-analyzer package changes are pretty simple, it just exposes a new analyzer that calls libpostal and adapts the response to the internal Pelias format.  To avoid having several projects change all at once, i modified the main entry point to look at the `api.textAnalyzer` value of Pelias config.  

### The query project 

The changes I’ve made to the query project so far are just the implementations of the 2 Query modules and their exports.  I’ve not modified FilteredBooleanQuery.  

### API

Since the text-analyzer selection is now environment driven, changes to the API are in 2 places:  `query/view/search.js` for figuring out which query to call and in post processing.  

#### Querying

I discussed the types of queries above so the changes to `query/view/search.js` are business logic to choose which Query module to use.  I’ve commented out a good chunk of the scoring/weighting logic in order to just get queries to run with the required fields.  The logic for query selection is very basic in that if libpostal returned a single coarse field and nothing else, GeodisambiguationQuery is used, otherwise FallbackQuery is.  


#### Post-processing

So far I’ve identified 2 post-query  processing steps:

- result trimming
- deduplication

##### Result Trimming

FallbackQuery issues range (not in the ES sense) queries to match less granular inputs in addition to the most granular input.  Therefore a post-processing function to remove all but the most granular results.  For example, the input “Lancaster, PA, USA” will search for:

- locality=Lancaster, region=PA, and country=USA
- region=PA and country=USA
- country=USA

The fallback is required in case there’s no city named Lancaster in Pennsylvania.  There is, however, so the locality record is the most granular and all other results should be removed.  The current state of the function is to check-for-existence and remove-less-granular in this order:

- venue
- address
- neighbourhood
- locality / localadmin
- county / macrocounty
- region / macroregion
- country

There’s a nuance and vagueness (what the French call “I don’t know what”) to the differentiation between locality and localadmin that users (or us for that matter) may not understand or appreciate so they should probably be treated as equivalent.  

This result trimming should probably only be applied for FallbackQuery instances since the whole idea of GeodisambiguationQuery is to search across all coarse layers.  
 
##### Deduplication

I haven’t explored it fully to understand the reasons why but `middlware/dedupe.js` is overly greedy in removing results.  For example, when searching for “Socorro” I would expect to see Socorro, NM in the results but it’s being deduce’d away.  I think this because geonames records with admin-lookup creates records that are substantially equivalent.  


## Outstanding Work

**tl;dr - we have a lot of work to do**

This section serves to start discussions on what is known knowns and known unknowns that we'll have to tackle at some point.  

### Exact Matches

This is probably my own lack of understanding of how ES works, but we’ll need to find a way to query for exact values, and potentially spelling corrections.  For example, if I search for `Red Lion, PA`, I get 2 results back:

- Red Lion, PA
- Red Hill, PA

Even though I specified locality=Red Lion in my ES query, it still returned other values that didn’t match exactly.  

### Shared node-postal instance

Our API is multicore as defined in `api/index.js`.  When I start the API in multicore mode, it slows down very quickly as it attempts to start multiple instances of libpostal.  I turned off multicore mode in order to start only a single libpostal instance, this won’t be a good solution in production.  I’ll need someone with advanced node knowledge to share a single libpostal instance.  Perhaps a microservice could solve this problem?  

### Special Case Queries

There are a fairly small number of cases where the limitation of libpostal only returning 1 thing can lead to situations where the GeodisambiguationQuery doesn’t do what we’ll need.  The best example of this is for the input “Ontario, CA”, which could be interpreted as both city/state and province/country.  We’ll need to modify one of the existing Query modules or write a new one that accounts for this and perform some detection in `query/view/search.js`.  

### Venue Proximity Search

Currently, FallbackQuery just searches for things that match on the terms, there’s no consideration made for proximity search.  For example, if a user enters “pizza, 1090 North Charlotte St, Lancaster, PA”, FallbackQuery disregards the address and searches for pizza venues that have city=Lancaster and state=PA.  This is equivalent to “pizza, Lancaster, PA”.  There’s no consideration of proximity or outside of the supplied city.  If the user enters, for example, “Pizza, Windsor, PA” where the city might have one pizza shop (or worse, none), we’d discount venues in neighboring towns which is mere miles away.  This becomes more evident when it’s not a universal term like “pizza” but something more abstract like “cowork spaces” where it’s very likely that the entered city may not contain anything but surrounding cities do.   

### Ambiguous Search

Even with proximity search enabled, if a user enters “Pizza Lancaster”, we’ll need to know which “Lancaster” the user was referring to.  There are 2 ways to approach this:

1. don’t search until the user has made a selection
2. sort the geoambiguities and perform a search on the most likely (highest ranked) result

In the case of Lancaster (without any additional contextual hints), Lancaster, PA will be the most likely result since it’s the largest city named Lancaster.  We will most likely need a new section of our response that lists the geoambiguities and the venue search results with the implicit understanding that the venue results are from the first in the geoambiguities list.  By returning both the venues and geoambiguities, we give clients the ability to present “did you mean?” functionality to users.  More broadly, doing a 2-stage geocode-then-search will resolve the case where the user enters an ambiguous location.  

### Suburb or City?

Due to OSM model issues, sometimes what we normally consider a city is identified by libpostal as a suburb which we treat as a neighborhood.  Normally treating a suburb as a neighborhood is a good thing as in:

```
> east village, new york city, ny

Result:

{
  "suburb": "east village",
  "city": "new york city",
  "state": "ny"
}
```

However, sometimes this isn’t correct, as in:

```
> santa monica, california

Result:

{
  "suburb": "santa monica",
  "state": "california"
}
```

Interestingly, libpostal gets it correct when the state is abbreviated:

```
> santa monica, ca

Result:

{
  "city": "santa monica",
  "state": "ca"
}
```

Al says this is fixable but I’m quite certain that it won’t get them all and there may be other instances where a coarse value could legitimately be something else so having the ability to handle that is important. 

### Spell Corrections

libpostal currently has limited ability to detect slight misspellings, though that might be an affect of OSM contributors not being able to spell rather than intentional behavior of libpostal.  For example:

```
> socoro, nm

Result:

{
  "city": "socoro",
  "state": "nm"
}
```

We'll have to enable some sort of spelling correction behavior in ES to take advantage of this.  This is important behavior for 5-box inputs that aren't analyzed so hopefully it can come along for the ride.  Until this is implemented the FallbackQuery will just fallback to New Mexico state but at least we don't fail catastrophically.  