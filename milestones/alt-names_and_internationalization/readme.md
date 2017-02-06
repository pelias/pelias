# Alt-Names and Internationalization

## Overview
The Pelias geocoder currently has a very simple understanding of names. Every place (from a country
to a venue) effectively has exactly one name[1]. This name is usually, but not always, in English.

In reality, most places are referred to in numerous ways. Some names are official, some are more
like nicknames. Most places have different names in different languages.

Handling nicknames, abbreviations, and other colloquial names are all considered to be under one
umbrella: alt-names.

Likewise, distinguishing and properly handling names in different languages will be referred to as
internationalization.

The principal technical challenges for both alt-names and internationalization are the same:

1.) The amount of data needed to be stored for use by Pelias will greatly increase.
2.) All queries will have to be rewritten to search across many possible names for a place.


### Data size
At its core, Pelias mostly stores names and latitude/longitude coordinates. Currently, we store the
name of a record any any of its parent elements. For example, the record for the city of New York
also stores the string 'New York' a second time, because it's located within the state of New York.
Likewise that record also contains the string 'United States', since New York City is in the United
States.

This approach makes things easy to generate results that contain the administrative information for
any record, but it wastes a lot of space. Every address record (there are hundreds of millions) in
the United States stores its own copy of the string 'United States'.

Since there are usually many (at least 10 and sometimes more than 100) alternative names or
translations for most country names, continuing with this data duplication would probably not be
feasible.

### Searching multiple names
With Pelias's current model, every place has just one name. There's never any confusion over what
fields to search, and its very clear that if a record does not match a query as well as another, it
shouldn't be returned in the results.

With multiple possible names, deciding which names to search against becomes important. Some of this
problem can be solved with a `lang` parameter that specifies which language to search in, or by
using the `Accept-Language` header passed by most browsers to do the same thing. However there will
be exceptions and obvious cases regardless. Many names are often written in English even by
non-English speakers, for example. A query like `search?lang=chinese&text=New York` should still
return New York.


## External Dependencies

Most of the alternative name and internationalization data will come from WOF and OSM.

These changes will probably require significantly changing how we use Elasticsearch. Making use of
new Elasticsearch features may help, and lack of features may make it harder to accomplish the
changes we want. Even though Elasticsearch is already a dependency, we should consider Elasticsearch
a dependency for finishing this project because it will be closely tied into the changes.


## Functionality

There are at least several sub-projects within this milestone:
1.) Refactoring our data storage to use a more normalized model, where the same name is not stored
many times.
2.) Adding all relevant alt-name and internationalization data from WOF and OSM into our imports.
3.) Add code in the API to detect which language a user prefers results in, and return those results
in the proper language. This will probably involve a combination of a new `lang` parameter and using
browser headers.
4.) Improve queries to be able to intelligently search multiple fields for both alt-names and
different langagues. Note that while #3 will _only_ change how the results are displayed, this will
change which results are actaully returned.
5.) Improve label generation code to be able to generate labels in many different languages. The
format of the labels may be different in different languages.



## Operations

Ideally this release will be identical from an operational perspective. However, the amount of
_unique_ data in Pelias will certainly increase, so loadtesting should be performed before rollout,
and performance should be acceptable.


## Documentation

A new section on internationalized results should be created.
Any new API flags should be added to the documentation for each endpoint.


## Validation

There are _lots_ of new queries that should work after this change.

Some examples for the search endpoint:

|input|lang|result|comments
|New York|en|New York, NY|base case|
|The Big Apple|-|New York, NY|example of a nickname|
|Munich|-|Munich, Germany|base case in English|
|München|de|München, Deutchland|language set to German gives German results|
|München|en|Munich, Germany|German name with English language specified should still work|



## Future Work

Most thought put into this feature has been around the `search` endpoint. The `autocomplete`
endpoint should not be negatively impacted by this work, but it may be improved later, if that's
more convenient.

## Notes

[1] Some places have multiple names stored in the Pelias data, but only one is ever searched. This
data is left over from years old attempts at internationalization and is not used.
