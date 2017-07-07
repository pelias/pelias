# Autocomplete Improvements v2

Track [milestone here](https://github.com/pelias/pelias/milestone/3)

Autocomplete has fallen behind search and needs some love. 
Here are the things we need to work on to get it inline with the other endpoints.

## Bugs

#### Analysis

- synonyms for the `street` layer 
  - [#563](https://github.com/pelias/pelias/issues/563)

#### Balance

- 'Union Square' POIs should sort before addresses on the street 'Union Square'
  - [#202](https://github.com/pelias/pelias/issues/202)
- various issues related to sorting when `focus.point` API used 
  - [#164](https://github.com/pelias/pelias/issues/164)
  - [#330](https://github.com/pelias/pelias/issues/330)

## New features / Research

- improve the parsing engine, attempt to reduce use of `addressit` 
  - [#423](https://github.com/pelias/pelias/issues/423)
  - [#272](https://github.com/pelias/pelias/issues/272)
  - [#510](https://github.com/pelias/pelias/issues/510)

- investigate the new ES2+ FST, the query language and potential performance gains. 
  - what is the effect on build times?
  - how much flexibility do we have for analysis? Does this mandate a certain version of ES?

- enable interpolation for autocomplete queries.

- enable language translation features for autocomplete.

- remove admin areas/ address records from elasticsearch - to reduce index size and increase performance. 
  - requires some research in to how many street names are in OA but not OSM and a plan to manage this.

- match admin fields by id instead of by string

- consider that alt names for venues/streets will be coming the in future and try to account for that in the data model.

## Roadmap

- fix known bugs (where major refactoring is not necessary)
- feature catchup (interpolation, language etc. where possible)
- complete the schema changes for /search (filter admin via id)
- upgrade elasticsearch

- concurrently
 - research FST, create performance benchmarking tooling
 - research placeholder autocomplete