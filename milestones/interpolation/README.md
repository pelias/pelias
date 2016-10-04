# Interpolation

[Track Milestone Here](https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+user%3Apelias+milestone%3A%22Interpolation%22)

## Overview

Housenumber interpolation is a key feature of any geocoder. Our goal is to implement a solution that will work across various 
conditions, such as availability of address range data (such as TIGER) or the presence of street geometry and existing address 
points along that street. See all the wonderful detailed writeups about this complex feature at these link:
 
### [Introduction](./introduction)
### [Conflation](./conflation)
### [Existing Standards](./existing_standards)
### [Proposed Solution](./design_doc)


## External Dependencies

We will be working closely with the Routing (Valhalla) team to post-process the data tiles, which we will use to index the roads.

## Functionality

- Import streets (centroid geometry) into a new `street` index as first class records
- Allow users to search for streets without house numbers
- Fallback to street centroid when housenumber is not found in the index
- Build address range data
- Search address range data when an exact address match is not found
- Search only range data when an address query is specified
- Consider deprecating point data for addresses in favor of new range data index 

## Operations

- Add new importer type for range data generation


## Documentation

- Add a new section describing interpolation
- Add new result property that indicates accuracy level of each record (point,interpolated,centroid)


## Validation

- Publish the results of benchmark / load-test execution and make scaling recommendations.
- Update / add acceptance tests to validate that the all required functionality has been implemented successfully.

|input query|expected result|
|---|---|
| 30 W 26th St | point |
| 5 W 26th St | interpolated |
