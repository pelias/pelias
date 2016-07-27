# Address Parsing (aka libpostal integration)

[Track Milestone Here](https://github.com/pelias/pelias/milestone/4)

## Overview

Pelias currently uses the `addressit` module to parse incoming query text and break it into corresponding parts where appropriate. This module presents many issues, main one being that it is not internationalization-friendly. It does marginally well with US and CA addresses, but fairs poorly when confronted with addresses from RU or DE to name a few.

The libpostal module, written by Al Barentine, does phenomenaly well across the world and is ready for integration with Pelias. The goal of this milestone is to incorporate the libpostal module into the API query processing workflow and then take advantage of the parsed out parts of the query to improve our query logic.

See [proposal document](proposal.md) for background and additional details.


## External Dependencies

Heavily depending on the [libpostal](https://github.com/openvenues/libpostal) module which is developed by Al Barentine under the [openvenues](https://github.com/openvenues) project.


## Functionality

- [ ] Refactor the address parsing component out of APi to allow us to easily swap out parsing logic.
- [ ] Replace `addressit` with `libpostal` in the API.
- [ ] Update query logic to accept specific address parts in the query instead of always relying on the `name` property.
- [ ] Allow query logic to fallback to admin areas where an exact address has not been located.
- [ ] Replace query bulding code in API to use the new more specific query logic.
- [ ] When multiple records match the query, the results should be sorted by a combination of population/popularity and distance from focus point where either of those data points exist.
- [ ] Decide how this will impact the `size` parameter, since we will often return only a single result, while the user might ask for 10 or more.
- [ ] Support ambiguous cases where the query matches areas of different types, e.g. `Ontario`. Sorting of results should follow the same rules as all other queries.
- [ ] Add a new property to each record in results to indicate the level of accuracy represented. ___Possibly only do this for address queries???___ They should be set as follows. Fill in others for each additional admin type if applicable.

|value|conditions|
|---|---|
| exact_addr | exact address found |
| fallback_locality | address not found, fallback to locality |
| fallback_region | address (and possibly locality) not found, fallback to region |
| fallback_country | nothing more granular found, fallback to country |

- [ ] When nothing has been found using this new strategy, attempt a query using the old query logic approach and evaluate if results are reasonable. This can be tricky, so should first consider how often this will get called. This will be particularly important in order to accommodate for misspelled queries, since the proposed implementation will typically not handle these cases correctly.

## Operations

- [ ] Add libpostal installation to existing Chef scripts. [issue](pelias/pelias#373)


## Documentation

Add a brand new documentation page devoted to the fallback mechanism. This is a new feature and significantly impacts results. Sweet all existing documentation to ensure all result examples are up-to-date, as many will have drastically changed for the better. There will be times when only a single result will be returned.

Update the section describing the `size` parameter to indicate that there will often be only 1 result and occasionally 0 results, even if the size is set to a larger number. The size will reflect the maximum number of results to return.


## Validation

- [ ] Publish the results of benchmark / load-test execution and make scaling recommendations.
- [ ] Update / add acceptance tests to validate that the all required functionality has been implemented successfully.

|input query|expected result|
|---|---|
| 30 W 26th St | many exact matches from various cities in USA) |
| 30 W 26th St, New York, NY | single exact match (with possiblity of duplicate) |
| Ontario | all the Ontario's from all the countries |
| text=Ontario&boundary.country=USA | only Ontario's from USA |
| Ontario, USA | only Ontario's from USA |
| FooBlah, New York | fallback to New York, make sure accuracy level is set to `fallback_locality` or `fallback_region` depending on which one is being returned |
| Paris | results should be sorted according to population |
| Whole Foods, New York | results should be only venues from New York area |
| add more here... | please :) |

## Future Work

- [ ] Update autocomplete to support the same query parsing and building logic.


