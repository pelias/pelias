# Alt-Names

[Track Milestone Here](https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+user%3Apelias+milestone%3A%22Alt-Names%22)


## Overview

Implement the ability to search across all the known names for a place, including various languages.


## External Dependencies

We will be relying on our data sources to provide the additional names for places.
WOF and OSM all have the concept of alt-names. We will need to work with data team
to ensure that the alt-names provided in WOF are curated and ready for consumption. 


## Functionality

- Store admin hierarchy place names in the native language of the parent country
  - for example `Кремль, Russia` should be `Кремль, Россия`
- Import and search nicknames for venues in OSM, such as airport codes for example
  - for example searching for `JFK` should return `John F Kennedy Int'l Airport`
- Import and search for WOF venues in many languages
- Refactor query logic to first search for all the admin areas separately and then use the found GIDs to perform the full place query
  - for example a query like `Lancaster, PA` will first query all admin layers for `PA` and once that has returned the GID for Pennsylvania another query will be formed to find anything named `Lancaster` that also has `parent.region_gid` equal to the GID from the fist query
- Search for WOF admin areas in many languages
- Search for OSM venues in many languages
- Import and search nicknames for venues in WOF
- Ensure performance is not diminished

_Note: GeoNames importers will not be updated as part of this work._


## Operations

- Potentially we would need to add more machines to support additional volume of data and more complex query logic


## Documentation

- A full sweep will be needed
- Additional examples of searching in different languages
- Blog post (at least one)


## Validation

- Publish the results of benchmark / load-test execution and make scaling recommendations.
- Update / add acceptance tests to validate that the all required functionality has been implemented successfully.

|input query|expected result|
|---|---|
| Статуя Свободы | Statue of Liberty, New York |
| Eiffel Tower | Tour Eiffel |
| Tour Eiffel | Tour Eiffel |
| München | Munich |
| JFK | John F Kennedy International Airport |
| USA | United States |
| Кремль, Россия | Кремль, Россия |
| Кремль, Russia | Кремль, Россия |


## Future Work

At this time we will not be changing the labels in the results.
