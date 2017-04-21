## Release Notes

> These are the release notes for _Pelias_, the open source project. It includes news on the latest
> code changes as well as new features. There are also [release notes](https://mapzen.com/documentation/search/release-notes/)
> specifically for the hosted instance of Pelias run by Mapzen, Mapzen Search.

## 21 April 2017
### New features
* Our first big ticket item is technically a new feature, a code level change, and a bug fix all in one! We've created a standalone microservice whose job it is to handle point-in-polygon requests. So with this release, all reverse queries specifying admin layers will be directed to this new service, instead of going to Elasticsearch like it used to. As a user, you won't see any difference in the interface to these types of requests and you don't have to take any action to use the new functionality. However, faster and better results will be apparent!
* Our second big ticket item (we know, 2 in one release is awesome sauce!) is the long awaited upgrade to `libpostal 1.0`. This is again a code level change that doesn't have any user interface implications but yeild significant improvements in results. We can tell just by the number of [old issues we were able to resolve](https://github.com/pelias/pelias/milestone/49?closed=1) as a result of this upgrade that this is a big moment for the Pelias engine. High-fives all around!
* You know how we started supporting search queries with only postalcodes in the, like `/v1/search?text=90210`? Well get excited, because we've added the ability to handle postalcode only queries in `structured` search as well! So queries like `/v1/search/structures?postalcode=90210` will now work. More info [here](https://mapzen.com/documentation/search/structured-geocoding/#postalcode).

### Code level changes
* For those hosting their own instances of Pelias, the new point-in-polygon service will have some impact on your setup. You can see the [pip-service README.md](https://github.com/pelias/pip-service) for setup details and don't forget to add the url to your new pip service instance to the API section of your Pelias config file. If you don't specify the `pipService` property in config, things will continue to work as they have before and Elasticsearch queries will continue to be used for coarse reverse requests.
```
{
  "api": {
    "host": "localhost:3100/v1/",
    "textAnalyzer": "libpostal",
    "pipService": "url to your pip service instance"
  },
  ...
}
```
* All the code is in place for checking the language headers in requests and returning results with admin names in the specified language. The functionality is not yet enabled and requires a link to a [`placeholder`](https://github.com/pelias/placeholder) service to work as expected.
* We've swapped the order of operation in the case of interpolation queries to deduplicate after interpolation has taken place, not before. When deduplicating before interpolation, street segments were getting removed as duplicates before they could be sent to the interpolation service for evaluation, causing us to miss some addresses.

### Bug fixes
* We fixed a few minor bugs related to address interpolation. There were cases where the results had a mix of street centroids and addresses and the correct address was not showing up first. More details [here](https://github.com/pelias/pelias/issues/528).
* There was an [issue with geonames admin records](https://github.com/pelias/pelias/issues/539) having incorrect ids in their admin hierarchy properties. They were basically mascarading as Who's on First ids leading to invalid results and general chaos. Well no more. We fixed it.


## 13 March 2017
### New Features
* We've added postalcodes to the Who's on First import process and enabled the postalcode-only query type, so users can now find postalcodes directly!
    * This update required additions to the Pelias schema as well as query building logic.
    * The download script in pelias-whosonfirst importer has also been updated to pull down postalcode data by default, so be aware when using that download command and when running the importer.
    * This also means Who's on First imports will now take roughly 3 times as long, if importing the whole world... Yeah, there are a LOT of postalcodes in the world! `Pelias <3 Postalcodes`

### Code level changes
* Refactored pelias-wof-admin-lookup and updated to this latest version in all importers.
    * This is in preparation for the upcoming fixes to our coarse reverse lookups.
    * Next step will be to direct the API to this new Point-in-Polygon service when available to get more accurate reverse geocoding results.
* Geonames importer interface has finally been updated to match our other importers.

### Bug fixes 
* Dependencies should now have the proper alpha3 ISO codes of their own in the country abbreviation (`country_a`) properties, instead of alpha2 of the parent country as it did previously. See [San Juan, PR](https://mapzen.com/products/search/?query=San%20Juan%2C%20PRI&endpoint=place&gid=geonames%3Alocality%3A4568127&selectedLat=18.46633&selectedLng=-66.10572&lng=-66.82571&lat=18.25413&zoom=9) for example.
* Washington DC wasn't getting a region abbreviation at all, but that's water under the [Arlington Memorial Bridge](https://mapzen.com/products/search/?query=Arlington%20Memorial%20Bridge%2C%20Washington%2C%20DC%2C%20USA&endpoint=place&gid=openstreetmap%3Astreet%3Apolyline%3A11785717&selectedLat=38.88725&selectedLng=-77.05541&lng=-77.13810&lat=38.88702&zoom=11) now!


## 1 February 2017
### New features
* We're working on some fancy new things in dev so our only new feature released this week is retrying timed-out elasticsearch requests.  By default, Pelias will retry a timed-out request up to 3 times before failing for good, though this number can be overridden by specifying `api.requestRetries` in your Pelias configuration.  

## 27 January 2017
### New features
* Big news! 🐯 we have soft launched our new [street interpolation](https://github.com/pelias/api/pull/769) service which includes [TIGER](https://en.wikipedia.org/wiki/Topologically_Integrated_Geographic_Encoding_and_Referencing) data. This allows us to return more address results than before. For more info see https://github.com/pelias/interpolation

### Bug fixes
* We've [fixed a bug](https://github.com/pelias/api/pull/780) where structured queries would always return 'fallback' as the 'match_type'.

## 17 January 2017
### New features
* The `/v1/structured` endpoint [now supports](https://github.com/pelias/api/pull/763) the `venue` parameter, which allows for searching for venues with a particular name.
* We've [improved result balance](https://github.com/pelias/api/pull/729) when using `focus.point` in the autocomplete endpoint. In particular, searching for cities far away from the focus point should work much better. More improvements to `focus.point` are planned for the near future.

## Developer changes
* We've finished adding Pelias config validation (for example [here](https://github.com/pelias/whosonfirst/pull/182) in the Who's on First importer) to all of our repositories. It should be much harder for simple config errors such as typos to go undetected!
* The checks run before dropping data using pelias-schema have [been improved](https://github.com/pelias/schema/pull/200). Accidentally deleting all your production data should now be even more difficult than before!

## 5 January 2017

### Code level changes
* We are now [considerably more strict](https://github.com/pelias/whosonfirst/pull/178) about read errors when loading Who's on First data. Any read errors, whether due to missing files or invalid JSON will cause the entire importer to fail immediately. This prevents builds from reporting succesful completion when some data is actually missing.
* The Elasticsearch `index_concurrency` setting has [been removed](https://github.com/pelias/schema/pull/198/commits/7224b1fd4fb5eceab8905c236478f03c6a8f590f). In theory this setting allowed tuning imports for better performance, but in practice it had little effect. It's going away in Elasticsearch 5, so this will make the transition that much easier.

## 28 December 2016

### New features

* Searches for `St Louis, MO` and `Saint Louis, MO` now return the same thing (the same goes for towns starting with `Mount`/`Mt` and `Fort`/`Ft`)

### Code level changes

* [Structured geocoding](https://mapzen.com/blog/structured-geocoding/) no longer fails horribly when the `address` parameter consists of only a house number

## 05 December 2016

### New features

* We've released what was previously referred to as component geocoding in the new structured geocoding endpoint! It lives at `/v1/search/structured`
* We fixed a bug where [specifying the same parameter twice](https://github.com/pelias/api/issues/744) (eg `/v1/search?text=paris&sources=geonames&sources=gn`) would cause a 500 error. It now returns a helpful 400 error message that includes which parameter is duplicated, so that the request can be fixed.
* Other errors that should have been 500 errors were [being returned with status code 400](https://github.com/pelias/api/pull/742). Fixing this will allow us to more quickly catch any 500 errors that happen in the future.

## 18 November 2016

### New features

* We've just released beta support for component geocoding so instead of passing in a single input to the `/v1/search` endpoint, the parts of an address can be sent to `/v1/beta/component`!  An example of this is `address=201+Spear+St&locality=San+Francisco&region=CA`.  We haven't officially named this geocoding type yet, so if you have a naming suggestion, please weigh in [here](https://github.com/pelias/pelias/issues/455)!  Our basic design doc for using this new beta feature is [here](https://github.com/pelias/pelias/tree/master/milestones/component_geocoding), please check it out.  We're still working out the final implementation (why it's currently deployed to our `/v1/beta` test bed) so check it out and don't hesitate to [raise any issues](https://github.com/pelias/pelias/issues) you might encounter.  Check out the [acceptance tests](https://github.com/pelias/acceptance-tests/blob/master/test_cases/component_geocoding.json) for some more examples.  

### Code level changes

* We're enabling support for more response scenarios from [libpostal](https://github.com/openvenues/libpostal)!  This release we're adding support for city+country, so requests for Paris, France and Reykjavík, Iceland are a lot cleaner.  
* Speaking of Reykjavík, Iceland, support for inputs containing diacritics has improved.  Now whether the input is Reykjavík, Iceland or Reykjavik, Iceland, results should be the same.
* Whether your input contains a 2- or 3-character ISO country code (`FRA` vs `FR`), we'll find it!

## 24 October 2016

### New features and fixes
* The `/v1/autocomplete` endpoint now supports [boundary.rect](https://mapzen.com/documentation/search/search/#search-within-a-rectangular-region) just like `/v1/search`
* Labels for administrative areas should be [improved in a few cases](https://github.com/pelias/whosonfirst/pull/139)

### Code level changes
* All Pelias code now requires Node.js 4.0 or newer! This means we can start using ES6 features. `let` us have a party to celebrate! :tada:
* Label generation code has been extracted into [pelias-labels](https://github.com/pelias/labels)
* Elasticsearch settings have been moved [out of a dark corner and into pelias/config](https://github.com/pelias/schema/pull/183)
* The whosonfirst importer has a better method for [calculating hierarchy information](https://github.com/pelias/whosonfirst/pull/157). It's simpler and should be more accurate and faster!

## 10 October 2016

* [libpostal](https://github.com/openvenues/libpostal), the super-sophisticated address parser, has been integrated for more accurate analysis of inputs at `/v1/search`.
* Street names containing post-directionals (e.g. - `186 Tuskegee St SE Atlanta GA` -> `186 Tuskegee St SouthEast Atlanta GA`) are now treated the same as their pre-directional brethren.
* 10/10, would release again - geocoding fallback rules that favor traditional geocoding behavior instead of search engine behavior

## 19 September 2016

Another data-only release. Stay tuned for next week!

## 12 September 2016

* Get excited for the addition of ✨ __STREETS__ ✨! That's right, with this release Mapzen Search gets a brand new `street` layer, which contains OSM street centroids. With this addition, if we can't find the exact address you're looking for we'll return the street record. Stay tuned for an in-depth blog post in the next few days. 👏

## 7 September 2016

* Crikey! We noticed we weren't handling Australian province abbreviations, so we [added support for them in our labels](https://github.com/pelias/api/pull/638).
* Geonames ADM3 records now are [correctly listed as localadmins](https://github.com/pelias/geonames/pull/120), not venues.
* Our wonderful, now departed intern made sure [Germanic street names are consistently handled](https://github.com/pelias/openaddresses/pull/68) (previously, some would end in -strasse while others ended in the abbreviation -str).
* Records with a Who's on First [dependency](https://github.com/whosonfirst/whosonfirst-placetypes#dependency) now [have that dependency listed in API responses](https://github.com/pelias/api/pull/643).

## 22 August 2016

No changes in functionality at all, just the freshest data! We did clean up some tests and do other work only visible to developers and those who run their own Pelias instance, but nothing major.

Stay tuned for next week's release where we already have some nice changes queued up.

## 18 August 2016

* After much feedback we've added the [`boundary.country` parameter for autocomplete](https://github.com/pelias/api/pull/634)! It works just like the one on the search endpoint.
* To help make Leaflet maps display results better, we now use [use the  `lbl:bbox` property on Who's on First records](https://github.com/pelias/whosonfirst/pull/122). This is useful for places like [San Francisco](https://en.wikipedia.org/wiki/Farallon_Islands) where the mathematical bounding box is bigger than people expect.
* The API was [incorrectly warning](https://github.com/pelias/api/pull/617) against using the `boundary.circle` parameter. Now it doesn't complain!
* We've added a new `/v1/nearby` endpoint that is currently in _early alpha_! There's no documentation, probably some bugs, and any part of the interface is still subject to change.
* Finally, we're now running Node.js 4 in production, rather than Node.js 0.12. For those running their own Pelias instance, be aware that we'll be dropping support for Node.js 0.12 in September. At first, things may work on Node.js 0.12, but we're very excited to finally start using ES2016, so that won't last too long.

## 8 August 2016

Incremental release resolving the final outstanding tasks in the Elasticsearch 2 upgrade.

We have registered a new website [http://pelias.io](http://pelias.io) which has information about the milstones we have planned for the current quarter.

* Elasticsearch 2+ does not support co-ordinate wrapping as it did prior to the 2 release. Some front-ends allow users to 'wrap' around the globe. Floats outside of the normal -90/+90 -180/+180 geographic coordinate ranges cause Elasticsearch to error. We added a function to the API which [unwraps these coordinates](https://github.com/pelias/api/pull/608); providing better compatibility with these tools.
- We added `borough` as a [possible layer for Geonames](https://github.com/pelias/api/pull/612)
- Since the beginning of the project the Elasticsearch `_index` name has always been hard-coded as 'pelias', the [index names configurable PRs](https://github.com/pelias/config/pull/30) allow this behaviour to be adjusted in your individual pelias config files.
- We [removed the focus.viewport API](https://github.com/pelias/api/pull/620) which was undocumented and never used outside of test suites.

## 2 August 2016

Another bigger than usual release, we had some ops related challenges to resolve after the update to Elasticsearch 2, as well as some data issues, but we also have some great improvements in store!

* We use more of the population data in Who's on First, which really helps more [relevant cities come up in searches](https://github.com/pelias/whosonfirst/pull/116).
* Searching for [only records in certain layers in Geonames](https://github.com/pelias/api/pull/573) now works! We keep adding better handling of Geonames data but sometimes our API code doesn't keep up with those changes.
* Labels now [include county names](https://github.com/pelias/api/pull/576) if there's no city (locality) info present. This helps with [addresses that are outside the bounds of any city](https://github.com/pelias/api/issues/575)
* Capitalization across all OpenAddresess records is now more consistent. We've tried to [properly capitalize all records that were either in all caps or all lowercase](https://github.com/pelias/openaddresses/pull/131). This is better in general, although there are certainly exceptions, and we welcome bug reports for those cases.
* Geonames records for New York City boroughs like Manhattan and Brooklyn are [now in the `borough`, rather than `locality` layer](https://github.com/pelias/geonames/pull/100). This makes them consistent with the records from Who's on First, which have been boroughs for some time.
* Addresses in the [Czech Republic](https://github.com/pelias/api/pull/594) now show the street name before the house number, in keeping with local customs
* When using the `/v1/place` endpoint, the source name can either be the full name or the [abbreviation](https://github.com/pelias/api/pull/574) (like the `sources` parameter to the search and autocomplete endpoints). We love saving people some typing :)
* We've made lots of internal changes like [reducing the size of our documents](https://github.com/pelias/model/pull/37), using a cleaner method to construct [layer filter queries](https://github.com/pelias/api/pull/580), removing dependencies on [packages we've deprecated](https://github.com/pelias/schema/pull/151), and allowing the Elasticsearch index name to be configured for both the [API](https://github.com/pelias/api/pull/595) and [schema](https://github.com/pelias/schema/pull/155) packages.
* In related internal changes news, we've also worked to make sure that all our code works with Node.js version 6, which was recently released! Support for Node.js 0.10, which is quite old and near end-of-life, is also starting to be removed.

We also have two **known issues** in this build:
* Some OpenAddresses records for the statewide data in Massachusetts, USA are incorrect. This is because of an issue [when changing data sources](https://github.com/openaddresses/openaddresses/pull/1892) that will be resolved in the next OpenAddresses build
* Geonames `localadmin` records, like the [City of New York](http://pelias.github.io/compare/#/v1/search%3Fsources=gn&layers=localadmin&text=city%20of%20new%20york) will have extra components in the label (in this case, "Brooklyn, New York"). The [fix for this](https://github.com/pelias/wof-admin-lookup/pull/53) is merged but was accidentally omitted from this build. Look forward to it next week!

## 07 July 2016

* **Big news:** We've finally [upgraded to Elasticsearch 2.3](https://github.com/pelias/pelias/issues/325)! This brings improved performance and more importantly sets us up for lots of improvements from the new features of Elasticsearch 2. Elasticsearch 1.7 is no longer supported.
* As part of the Elasticsearch 2 upgrade we've also improved a few edge cases for searching for numeric values, and with single character tokens. You can [read more](https://github.com/pelias/pelias/issues/325#issuecomment-230724630) in the Github issue for the upgrade.
* We've also fixed some lingering issues where a few places in Denmark were listed as [being part of Sweden](https://github.com/pelias/pelias/issues/368). This was due to the same data bug as mentioned in our recent [blog post](https://mapzen.com/blog/assult-on-copenhagen/).
* The OpenAddresses importer now has better [whitespace cleanup](https://github.com/pelias/openaddresses/pull/130), so there won't be any extra spaces in street names.
* We recently added data to new [layers](https://mapzen.com/documentation/search/search/#filter-by-data-type) in Geonames, but the API didn't know about it, and prevented you from searching for them. We [fixed it](https://github.com/pelias/api/pull/573).

## 13 June 2016

* Who's on First importer: records now use the label centroid if it's present. The previous behavior was to always use the center of the record's bounding box. In cases like [San Francisco](https://github.com/pelias/pelias/issues/356), this caused the record to not show up where people expect!
* Openstreetmap importer: A bug in config parameter handling that caused admin lookup to be disabled when it shouldn't was fixed. Thanks to [@dylanFrese](https://github.com/DylanFrese) for helping us catch this tricky one.

## 26 May 2016

* We did it... we removed an Elasticsearch analyzer that was presumptuously assuming all queries were in English! The `k-stemming` analysis would do strange things like turn Daly into Dale, so finding "Daly City" was a challange. Well, no more! Word of warning, in `/search` we are now less forgiving when someone uses a plural version of a word where the real name is singular.

## 23 May 2016

* All the extra 0's have been eradicated in addresses coming from OpenAddresses. You should not see any house numbers that reduce to 0 or any leading 0's in house numbers.
* Added the mysteriously missing `source_id` property to response features. This property represents the original id at the source, if one existed, like in OSM and WOF. Where it didn't we made one up to help uniquely identify each record.

## 09 May 2016

* Cleaned up some invalid address data from our OpenAddresses import by removing anything with words like `NULL`, `UNDEFINED`, and `UNAVAILABLE`.
* Improved error reporting in the API so users can decipher what went wrong much easier. More specifically, there are errors that Elasticsearch reports and we propogate up to the API response.

## 29 April 2016

* A big improvements to autocomplete results coming from numerous bug fixes and improvements! More details can be found in the pull requests: [pelias/schema#127](https://github.com/pelias/schema/pull/127) and [pelias/api#526](https://github.com/pelias/api/pull/526). Some highlights include:
 - Single digit housenumbers like `8 Main St` can be found more easily
 - Support for searching for the street name before the house number, as is common in many European countries, is improved.
 - Searches that end in common words no longer return no results. These were being treated as stopwords internally in Elasticsearch. Now queries such as `Moscone West` will work better
* [Remove OpenAddresses records with 0 housenumbers in US/CA](https://github.com/pelias/openaddresses/pull/92)

## 18 April 2016

* Address parsing now works without spaces after commas. This was our bad. Feel free to leave those spaces out as long as you provide commas to delimit admin parts.
* Further streamlining of labels. You can expect the labels to a have more consistent and minimal feel. If the results are coming from New York, expect boroughs such as Manhattan, Brooklyn, Queens, etc. to be part of the label. You're welcome New Yorkers! :heart:
* Fixed a bug where specifying `layers=macrocounty` would fail due to a typo in the API code. You can see how easy it is to mistype `macrocounty` and not notice that `macrocountry` is incorrect. #onlyhuman


## 08 April 2016

This release marks the official integration of the Mapzen `Who's on First` data set into Mapzen Search. This data is replacing `Quattroshapes` across the entire service. Any forward usage or references to `Quattroshapes` will be replaced with `WhosOnFirst`. This substitution allows us to fix long-standing encoding issues in administrative hierarchy place-names. We've also added a bounding box for individual features in the results, not only the all-encompassing bounding box at the top level of the geojson results. Also, the all-encompassing bounding box will extend to include the bounding boxes of all the features in the results, not only their centroids.
Another major improvement that many have been waiting for is the addition of more filters for the `/autocomplete` endpoint. Users can now ask `/autocomplete` to filter by `layers` and `sources`, as documented [here](https://mapzen.com/documentation/search/autocomplete/#available-autocomplete-parameters).
See the detailed list of changes below for more specifics.

* Switched from `Quattroshapes` to `WhosOnFirst` as the canonical source for administrative hierarchies and corresponding geometries.
* No longer importing `Quattroshapes` data since `WhosOnFirst` contains all those records and more. Going forward, any use of `quattroshapes` or `qs` in queries will resolve to `whosonfirst` or `wof` automatically.
* New `bbox` property has been added to individual results, for which geometry was available in the original source. This does not affect POI and address data.
* Drastic improvements have been made to the label generation logic.
* `id` and `gid` format has changed to make the ids more unique.
* New id format resolves previously outstanding bugs related to `geonames` ids being invalid for lookup via the `/place` endpoint.
* Additional place-types have been introduced, such as `macroregion`, `macrocounty`, and `borough`.
* `gid` values have been added for each parent in the admin hierarchies of results.
* `/autocomplete` now allows filtering by `sources` and `layers`.
* Fixed a bug that allowed `/autocomplete` to accept the `size` parameter. The default and only size of `/autocomplete` results is now `10`, as originally intended.
