# Alt-Names

[Track Milestone Here](https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+user%3Apelias+milestone%3A%22Alt-Names%22)


## Overview

Implement the ability to search across all the known names for a place, including various languages.


## External Dependencies

We will be relying on our data sources to provide the additional names for places.
WOF and OSM all have the concept of alt-names. We will need to work with data team
to ensure that the alt-names provided in WOF are curated and ready for consumption. 


## Functionality

- [ ] Import all alt-names from OSM and WOF, avoiding GeoNames at this time
- [ ] Support alt-names for venues and coarse admin layers, but not for addresses and streets 
- [ ] Add alt-names to the query logic to allow searching for things by their alt-names
- [ ] Support multiple names in different languages
- [ ] Support multiple names in a single language (nicknames, airport codes)
- [ ] Ensure performance is not diminished


## Operations

- [ ] Potentially we would need to add more machines to support additional volume of data and more complex query logic


## Documentation

- [ ] A full sweep will be needed
- [ ] Additional examples of searching in different languages
- [ ] Blog post (at least one)


## Validation

- [ ] Publish the results of benchmark / load-test execution and make scaling recommendations.
- [ ] Update / add acceptance tests to validate that the all required functionality has been implemented successfully.

|input query|expected result|
|---|---|
| Статуя Свободы | Statue of Liberty, New York |
| Eiffel Tower | Tour Eiffel |
| Tour Eiffel | Tour Eiffel |
| München | Munich |
| JFK | John F Kennedy International Airport |
| USA | United States |


## Future Work

At this time we will not be changing the labels in the results.
