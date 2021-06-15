
## Interpolation

This document outlines a proposal for refactoring how street addresses are stored and retrieved in Pelias.

> An introduction to addresses in Pelias can be found in: https://github.com/pelias/pelias/wiki/Interpolation:-introduction

The strategic goals of the work are:

- Ensuring every street in Openstreetmap is indexed and retrievable.
- Supporting address ranges as provided by Openstreetmap, TIGER, et al.
- Combining and de-duplicating distinct address point data sets.
- Designing the system to scale beyond 1B address points.
- Allow room for future extension / improvements.

These changes will allow for the following user experience improvements:

- Provide house number interpolation where address range data exists.
- Fall back to providing a street centroid in lieu of a satisfactory house number.
- Reduce noise by only showing a maximum of one result per street.

### Source data

The work requires a conflated `road network` dataset and one or more `house number` datasets in order to function. Additional house number data sets will improve the coverage and accuracy of the system.

> The problem of conflation is outlined in more detail in: https://github.com/pelias/pelias/wiki/Interpolation:-conflation

### Road network

It is essential to have a pre-processed and conflated road network in order to:

- Reduce / avoid duplicate street names in results.
- Provide line strings which can act as interpolation guides.
- Ensure that interpolated points do not lie in a driving hazard.

Three strategies for conflating the OSM road network were considered:

- Create a new system to conflate the OSM ways *- too time consuming and error prone*.
- Extract data from vector tiles *- not appropriate due to file size optimizations and entity merging*.
- Utilize the routing graph *- similar domain, not concerned with any entities except roads*.

#### Exporting the Valhalla routing graph

![generic graph image](https://i.stack.imgur.com/JrBdQ.png)

Valhalla doesn't store OSM ways, it breaks up the source data in to a graph of 'edges'. Each edge is marked up with [meta data such as this](https://gist.github.com/missinglink/b2ac67f51d132b591868a9ef60061c43).

By [iterating over all the tiles](https://github.com/valhalla/tools/issues/60) we can walk the graph and join adjacent road segments with the same name.

The process would take around 2 hours and would produce a dump file containing:

- a single continuous line string representing the geometry of the road
- the street name
- (optionally) meta data about the street such as direction
- (optionally) a centroid value for the street

**note:** the algorithm will favour the longest contiguous path, in the case of disjoined streets and geometries that cannot be represented using a single line; a second line will be produced with the same street name.

Future work can be planned in v2 to:

- Improve the name matching algorithm.
- Reduce the amount of duplicate line segments produced.
- Break line strings on geographic / political boundaries.

### Point data

![generic house number image](https://wiki.openstreetmap.org/w/images/f/f2/Housenumber_example_kms_2.png)

Point data from Openstreetmap and OpenAddresses will need to be associated to the correct segment of the road network (a single entry from the dump above).

Given only a lat/lon pair and a street name, the system must be able to quickly find the appropriate road network segment and retrieve a unique ID representing it.

As above, the quality of the street normalization and spelling error detection will affect the quality of the matching algorithm.

The house number point should then be [projected on the line string](http://stackoverflow.com/questions/10301001/perpendicular-on-a-line-segment-from-a-given-point), this will give us a new point which is guaranteed to lie on the line string.

The projected point data is saved along with the original position, one will be used for exact matches while the other will provide interpolation data.

### Range data

![range](/img/interpolation/osm-interpolation-tag.png)

Range data from Openstreetmap and TIGER will also need to be associated to the correct segment of the road network.

> Information about available ranges is outlined in more detail in: https://github.com/pelias/pelias/wiki/Interpolation:-existing-standards

There is a performance vs. index size tradeoff that can be made here, either the range data can be 'expanded' at index time or at query time. It seems that query time expansion of ranges would be preferable as it keeps the index smaller and allows behavioural modifications without a full reindex.

Judging by the tag statistics in the link above we will get much more value from supporting `addr:interpolation:*` tags than TIGER `from_address_right` etc tags. I would recommend not supporting TIGER tags in the v1 work.

The OSM interpolation tags simply join two of the points mentioned above, so importing these ranges is very easy, simply associate them to the same road network as the child points, no further project need be performed at this time.

### Importing in to Pelias

Pelias will require an import of one document per line string in the road network, this will be in the ten-of-millions.

This data should be imported in to a new layer, named `street` which distinguishes it from `address` and `venue` data.

Each record will require a centroid, if one is not provided in the source data then it will need to be computed.

The line strings should not be stored in Elasticsearch, they have the potential to be very large (10's of GB).

### Query logic

```
Can we determine candidate street(s) based on the input test?
[no] Fail

Did the user provide a house number in the query?
[no] Return the street centroid

Do we have point data for the requested house number?
[yes] Return the exact position

Do we have an address range encompassing the requested house number?
[yes] Return the interpolated position
[no] Return the street centroid
```
