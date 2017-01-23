# TIGER Address Ranges

[Track Milestone Here](https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+user%3Apelias+milestone%3A%22Get+em+TIGER%22+)


## Overview

With point-based address interpolation in place and the ability to ingest range data prepared, we will
incorporate the latest TIGER address range data in the USA. This will provide full address coverage in the USA. 

## External Dependencies

We expect to spend some time learning the TIGER data format.

## Functionality

- [ ] Parse the TIGER data to extract road segments and house number ranges
- [ ] Map TIGER house numbers onto the existing interpolation database
- [ ] Ensure that interpolation results reflect the new TIGER source data
- [ ] Add TIGER to the list of data sources and include links to license


## Operations

- [ ] Automate the download and local storage of the latest TIGER data 
- [ ] Incorporate new TIGER importer into the automated interpolation build


## Documentation

- [ ] Update data sources documentation along with license information
- [ ] Update Pelias install documentation to include the new importer


## Validation

- [ ] Publish the results of benchmark / load-test execution and make scaling recommendations.
- [ ] Update / add acceptance tests to validate that the all required functionality has been implemented successfully.

|input query|expected result|
|---|---|
| <address_not_found_with_point_interpolation> | <result_provided_using_tiger> |


## Future Work

This will focus on TIGER data for the United States only. We can incorporate Canada in future milestones. 
