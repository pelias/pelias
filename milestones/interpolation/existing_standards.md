## existing standards

### TIGER

![tiger](https://www.census.gov/main/www/img/smalltiger.gif)

The US census bureau have produced an export of street centerline coverage in the United States, Puerto Rica and the Island Areas since 1989, new versions of the data are released periodically on [their website](https://www.census.gov/geo/maps-data/data/tiger-line.html).

The TIGER/Line files contain a schema for describing address ranges:

> 5.12.4 Address Ranges

> Linear address range features and attributes are available in the following layer:
'Address Range Feature County-based Shapefile'

> The address range feature shapefile contains the geospatial edge geometry and attributes of all
unsuppressed address ranges for a county or county equivalent area. The term "address range"
refers to the collection of all possible structure house numbers between the first structure house
number to the last structure house number of a specified parity along an edge side relative to the
direction in which the edge is coded. All of the TIGER/Line address range files contain potential
address ranges, not individual addresses. Potential ranges include the full range of possible
structure numbers even though the actual structures may not exist. Single-address address ranges
are suppressed to maintain the confidentiality of the addresses they describe.

 The most relevant properties include (but may not be limited to):

|property|description|
|---|---|
|LFROMHN|From House Number associated with the address range on the left side of the edge; SIDE=L|
|LTOHN|To House Number associated with the address range on the left side of the edge; SIDE=L|
|RFROMHN|From House Number associated with the address range on the left side of the edge; SIDE=R|
|RTOHN|To House Number associated with the address range on the left side of the edge; SIDE=R|
|PARITYL|Left side Address Range Parity|
|PARITYR|Right side Address Range Parity|

For reference, this is how they define terms in their glossary:

> 4.1 Edge

> A linear object (topological primitive) that extends from a designated start node (From node) and continues to an end node (To node). An edge’s geometry can be described by the coordinates of its two nodes, plus possible additional coordinates that are ordered and serve as vertices (or "shape" points) between these nodes. The order of the nodes determines the From-To orientation and left/right sides of the edge. Each edge is uniquely identified by a TLID. A TLID is defined as a permanent edge identifier that never changes. If the edge is split, merged or deleted its TLID is retired.

> 4.10 Parity

> Parity is an attribute field in the addrfeat.shp used to indicate whether address house numbers
within an address range are Odd (O), Even (E), or Both (B) (both odd and even).

note: for a full list of properties see page 79 of the [TIGER technical documentation](https://www2.census.gov/geo/pdfs/maps-data/data/tiger/tgrshp2013/TGRSHP2013_TechDoc.pdf).

---

### Openstreetmap

![osm](/img/interpolation/Logo_by_hind_128x128.png/120px-Logo_by_hind_128x128.png)

A failed import of TIGER@2005 was attempted during 2005/2006, it was aborted and the data purged due to [data integrity problems](http://wiki.openstreetmap.org/wiki/Old_TIGER_Import_2005/2006).

The first [successful import](http://wiki.openstreetmap.org/wiki/TIGER_2005) was made in 2007/2008 using a some new ruby scripts, there is still some confusion around whether the importer Dave Hansen imported TIGER@2005 or TIGER@2006.

The TIGER import still has a [long list of issues](http://wiki.openstreetmap.org/wiki/TIGER_fixup) and the wiki clearly says "It is unlikely that the TIGER data ever will be imported again."

The TIGER import laid the foundations for the US road network in OSM and due to its lineage; inherited some of the TIGER/Line attributes mentioned above, a discussion of how those properties were mapped from one dataset to another can be [found in the wiki](http://wiki.openstreetmap.org/wiki/TIGER_to_OSM_Attribute_Map)

===

#### tiger:*

For a full list of tiger tags in use see: [taginfo](http://taginfo.openstreetmap.org/search?q=tiger%3A), the most common metadata tags are:

|total|tag|description|
|---|---|---|
|~13M|tiger:cfcc|[Census Feature Classification Code](http://wiki.openstreetmap.org/wiki/TIGER_to_OSM_Attribute_Map#TIGER_CFCC_to_OSM_Attribute_Pair) (CFCC). replaced by MTFCC in 2007|
|~13M|tiger:county|Name of County followed by the abbreviated state name|
|~12M|tiger:reviewed|no was set on all ways in the TIGER import. It is intended as a way of tracking TIGER fixup progress. However it does not succeed in this aim and is largely pointless|
|~6M|tiger:tlid|TIGER permanent edge ID|

Additionally there are tags which provide a more granular representation of street names:

|OSM Key|TIGER Field|Example|
|---|---|---|
|tiger:name|"#{fedirp} #{fename} #{fetype} #{fedirs}".strip|"NW Chester St S"|
|tiger:name_direction_prefix|fedirp|"NW", "Southwest"|
|tiger:name_base|fename|"Chester"|
|tiger:name_type|fetype|"Street", "Ave"|
|tiger:name_direction_suffix|fedirs|"S"|

And tags which represent address ranges:

|OSM Key|TIGER Field|
|---|---|
|from_address_right|fraddr|
|to_address_right|toaddr|
|from_address_left|fraddl|
|to_address_left|toaddl|
|zip_left|zipl|
|zip_right|zipr|

For each additional address range:

|OSM Key|TIGER Field|
|---|---|
|from_address_right_1|fraddr|
|to_address_right_1|toaddr|
|from_address_left_1|fraddl|
|to_address_left_1|toaddl|
|zip_left_1|zipl|
|zip_right_1|zipr|

et cetera

**note:** there are only ~1600 occurrences of `from_address_right` and `from_address_left` in OSM. see [taginfo](http://taginfo.openstreetmap.org/search?q=from_address_left).

===

#### addr:interpolation:*

This is a more global/general approach towards defining house number ranges in OSM.

[The wiki](http://wiki.openstreetmap.org/wiki/Addresses#Using_interpolation) states that the tag value should be a numeric offset which indicates "the value to increment between house numbers" (so generally `2` in western countries which follow the 'zigzag' schema).

There are also special cases where the tag value is either the string `odd` or `even` (there is also `all` but it is not clear what this means; presumably both).

In this case `odd` is equivalent to having an offset `2` but also implies that the range starts at an odd number. The inverse is true for `even`.

For a full list of `addr:interpolation` tags in use see: [taginfo](http://taginfo.openstreetmap.org/keys/addr:interpolation#values), the most common tag values are:

|total|tag|
|---|---|
|~1M|addr:interpolation=even|
|~1M|addr:interpolation=odd|
|~18k|addr:interpolation=all|
|~1.6k|addr:interpolation=alphabetic|
|~200|addr:interpolation=4|
|~150|addr:interpolation=1|
|~100|addr:interpolation=2|

It's natural to assume that the `addr:interpolation` tag is commonly added to ways which also contain a `highway:*` tag, looking at [taginfo](http://taginfo.openstreetmap.org/keys/addr%3Ainterpolation#combinations) shows us that only `643` of the ~2M interpolation tags actually belong to road network segments.

The majority of `addr:interpolation` tags are 'invisible ways' which represent the path along which the houses will sit, on the base map they look like this:

![basemap interpolation](/img/interpolation/osm-interpolation-tag.png)

In the example above the mapper has entered the first node and last note of the sequence, they tagged each with the `addr:street` and `addr:housenumber` tags and then joined the two with [a way](https://www.openstreetmap.org/way/251485113) which contains a single tag `addr:interpolation:odd`, the way is represented by a dashed line.

This seems to be the most common use of the tag, in some cases the mapper is simply trying to cover a large amount of ground quickly, maybe they got tired of drawing the individual building outline for each house or maybe the area is still under construction, the wiki contains some additional tags for defining the [confidence of the survey](http://wiki.openstreetmap.org/wiki/Addresses#Using_Address_Interpolation_for_partial_surveys).

In some areas the interpolation values have been replaced by individual building outlines, in other areas it's more common, such as:

![basemap interpolation](/img/interpolation/osm-interpolation-coverage.png)

I would be interested in doing more research in to the amount of house numbers available in OSM using `addr:street` and `addr:housenumber` vs. using `addr:interpolation:*`. It would take some time to compute but would make a great blog post.
