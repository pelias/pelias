# Interpolation

[Track Milestone Here](https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+user%3Apelias+milestone%3A%22Interpolation%22)

## Overview

Housenumber interpolation is a key feature of any geocoder. Our goal is to implement a solution that will work across various 
conditions, such as availability of address range data (such as TIGER) or the presence of street geometry and existing address 
points along that street. See all the wonderful detailed writeups about this complex feature at these link:
 
### [Introduction](introduction)
### [Conflation](conflation)
### [Existing Standards](existing_standards)
### [Proposed Solution](design_doc)


## External Dependencies

We will be working closely with the Routing (Valhalla) team to post-process the data tiles, which we will use to index the roads.

## Functionality

- [ ] <TBD> list out all the required features here.
- [ ] <TBD> link to github issues as they are generated.
- [ ] <TBD> ensure each new issue is added to the github milestone.


## Operations

<TBD> Add any work required on the ops side.


## Documentation

<TBD> Call out places that need to be updated with links to github markdown files


## Validation

<TBD> 
- [ ] Publish the results of benchmark / load-test execution and make scaling recommendations.
- [ ] Update / add acceptance tests to validate that the all required functionality has been implemented successfully.

|input query|expected result|
|---|---|
| insert | test |


## Future Work

<TBD> Outline anything that won't be done as part of this milestone but should be tracked and prioritized in the future.

