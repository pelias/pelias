# Coarse Reverse Geocoding

[Track Milestone Here](https://github.com/issues?utf8=%E2%9C%93&q=user%3Apelias+milestone%3A%22Coarse+Reverse+Geocode%22)

## Overview
The current coarse reverse geocoding solution is effectively broken and often results in incorrect results.
 It needs to be updated to ensure that a proper point in polygon lookup takes place instead of
 estimating with a best guess from nearby centroids of admin areas.

## [Background](background.html)

## External Dependencies
None

## Functionality

- [ ] Ensure that a true point in polygon lookup is used to compute results for coarse reverse queries
- [ ] Revisit the available filters and map their effect on query logic

## Operations
There will potentially be a significant ops component involved with this work.
 We would like to incorporate the point-in-polygon lookup in such a way that it can be hosted independently
 of the entire Pelias infrastructure.

## Documentation

- [ ] Update coarse reverse documentation

## Validation

<TBD> 
- [ ] Publish the results of benchmark / load-test execution and make scaling recommendations.
- [ ] Update / add acceptance tests to validate that the all required functionality has been implemented successfully.

|input query|expected result|
|---|---|
| | |
| | |
| | |


## Future Work

This will not involve changes to the venue and address layer reverse queries.
