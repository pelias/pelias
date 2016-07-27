# WOF Venues Import

## Overview

The Who's on First dataset provides a large number of venue and point of interest (POI) records. Mapzen Search should allow users to search all of those POIs. This means that the importing of these records must be added to the import pipeline. They should be updated automatically as part of the regularly scheduled weekly build. The records should include a full administrative hierarchy with respective Pelias gids for each parent. In cases where a POI had address information, a duplicate record containing only the address must be created and added to the address index.

## External Dependencies

In order for this work to be completed successfully, WOF bundles must be implemented and set up to be published with updates regularly.

## Functionality

### Required
- [ ] Implement script(s) to download venue data bundles to a target machine. This will be used by engineers to set up their local development environments as well as by the ops framework to setup dev/staging/production import pipeline worker machines. :question: Determine if this should include campus records, since all airports are stored with type campus as opposed to venue. :question:
		
- [ ] Improve WOF venue bundle generation code to build more venue bundles. Ideally this work would result in a single planet-wide bundle of venue data that can be downloaded without the use of GitLFS.
- [ ] Update existing WOF importer to index venue records as well as administrative areas.
- [ ] Update the logic that guards against invalid combinations of layers and sources parameters in queries. API should allow users to search with sources=wof&layers=venue,address.
Update existing admin lookup code to ensure that it ignores WOF venue data, even when it’s present in the data directory specified in the configuration properties.
- [ ] Existing chef scripts must be updated to download venue bundles prior to beginning the WOF import process.

### Documentation
TBD: call out places that need to be updated with links to github markdown files

### Validation
- [ ] Publish the results of benchmark / load-test execution and make scaling recommendations. It is possible that some additional scaling considerations might be required to support the new volume of data, as this expected to bring in an additional 10-15 million new records.
- [ ] Update / add acceptance tests to validate that the new venue data is getting indexed and searched as expected. The following are potential test cases. It can be assumed that all new tests would have sources=wof.

| input text | expected gid |
| --- | --- |
|Statue of Liberty | wof:venue:571724043|
|laguardia|wof:venue:102526001|
|mapzen|wof:venue:420573371|
|Museum Europäischer Kulturen|wof:venue:186122699|
|Thieß|wof:venue:270288293|
|30 w 26th street _(future work)_|wof:address:420573371|
|Neuer Kamp 2, Kellinghusen _(future work)_|wof:address:270288293|


### Future Work
- [ ] Import category tags to allow searching WOF venues by category, similarly to all existing venue records. Category taxonomy and mapping info in https://github.com/pelias/categories should be used to ensure normalization across all importers.
- [ ] Create separate address records for each venue that has a fully specified address. This should be done in order to mimic what is currently happening in the OSM importer. The duplicated address record should have the name property set to the street address label and added to the address index, as opposed to venue. This can mirror the address duplicating code in the OSM importer and ideally result in minimal code duplication where possible.
