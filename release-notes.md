## Release Notes

> These are the release notes for _Pelias_, the open source project. It includes news on the latest
> code changes as well as new features. There are also [release notes](https://mapzen.com/documentation/search/release-notes/)
> specifically for the hosted instance of Pelias run by Mapzen, Mapzen Search.

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
