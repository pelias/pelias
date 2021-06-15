## Conflation

Pelias imports address data from many different sources; some contain line geometry while others contains address points or interpolation ranges.

None of our source data sets currently contain street or address concordances, grouping data is necessarily in order to establish the data refers to the same entity/entities.

It's important to be able to combine these data in order to:

- increase our street address coverage
- reduce 'holes' in the data which can cause a loss of precision
- associate point data to road network data
- deduplicate results

This document outlines the different types of data we import and suggests some grouping techniques we can use to associate them.

### Conflation for search

Conflation for search is a similar process as for routing and display, the only major difference is that we aim to reduce the amount of duplicate street names to a minimum.

Returning a list of osm ways is not acceptable for search as it will result in an experience such as:

![conflation-problem](/img/interpolation/search-conflation-problem.png)

A better user experience would be to provide 'address ranges' of the street:

![conflation-problem2](/img/interpolation/search-conflation-problem2.png)

An ideal experience would be to provide the exact street address:

![conflation-problem3](/img/interpolation/search-conflation-problem3.png)

### Grouping Openstreetmap entities

Conflation of openstreetmap entities is a well studied domain; both the routing team and the vector tiles team members have extensive experience in this area.

#### Single line

The most basic streets in Openstreetmap are an ordered collection of 'nodes' grouped together in a 'way', the street is given a `name` tag and a `highway:*` tag:

| geometry | tags |
|:-:|:-:|
| ![osm-street-simple](/img/interpolation/osm-street-simple.png) | ![osm-street-simple-tags](/img/interpolation/osm-street-simple-tags.png) |

These entities are relatively simple to import as they do not contain multiple line segments, some care will need to be taken when computing the centroid value; which should lie on the line string rather than in the center of the bounding-box.

#### Multiple lines

More complex roads require the road be split up in to 2 or more 'ways', such as this example, we have a road split in to 3 different 'ways'; two road segements with a roundabout in the middle:

| geometry | tags |
|:-:|:-:|
|![osm-street-multiple-1](/img/interpolation/osm-street-multiple-1.png) | ![osm-street-multiple-1-tags](/img/interpolation/osm-street-multiple-1-tags.png) |
|![osm-street-multiple-2](/img/interpolation/osm-street-multiple-2.png) | ![osm-street-multiple-2-tags](/img/interpolation/osm-street-multiple-2-tags.png) |
|![osm-street-multiple-3](/img/interpolation/osm-street-multiple-3.png) | ![osm-street-multiple-3-tags](/img/interpolation/osm-street-multiple-3-tags.png) |

These entities are usually related by common 'nodes', usually at the extremes of the constituent line segments.

In some cases the line string may be 'broken', it may not share common nodes due to an obstacle such as an intersection or another feature.

A spatial search can be performed to attempt to find other nodes in close spatial proximity which belong to a way which share the same name.

Some caveats to avoid are:

1. some cities have two or more roads with the same name, joining them would be incorrect.
2. there is potential for different spelling between ways, a street name normalization function should be used to detemine if the names 'match' or not.

Again, some care must be taken when computing a centroid value for the network. There is potential for the joined road network to be very long, it may span several different neighborhoods (or even states!).

There will be cases where a single centroid value doesn't make sense. It might be best to split these entities in to 2 different road networks in order to provide a more intuitive search to the user.

#### Disjoined lines

The most complex case is when two parts of are road a broken up by large spatial gaps, this is fairly common in large cities where building development has divided existing streets.

A good example is Golden Gate Park in San Francisco, here you can see that all the north/south avenues are completely disjoined by the park:

![golden-gate](/img/interpolation/golden-gate-park.png)

New York city has adopted an convention for these disjoined streets, usually prefixing their names with either 'East' or 'West' in order to disambiguate the two sides of the park.

Parks are only the 'tip of the iceberg' regarding disjoined road networks, there are very long and complex networks just as major highways to consider as well as cases where roads change names and then change back again.

It's also common for road networks to be disjoined multiple times, such as in [this example](https://gist.github.com/missinglink/564835c5465bf83dac9056d77da9c529).

There is much more complexity to this problem than covered here, again great care must be taken when computing a centroid value for these networks as:

1. a bounding box centroid would result in the centroid being inside the obstacle rather than on the road network.
2. the road network can be very large, spanning multiple cities/states or countries!

![oresund-bridge](/img/interpolation/oresund-bridge.png)

#### Irregular geometries

The world is a weird and wonderful place, it's best not to assume anything about how road networks are constructed, there will always be unusual geometries to be found, such as this:

![earls-court-sq](/img/interpolation/earls-court-square.png)

It's best not to dwell on these unusual geometries as they are the exception rather than the rule.

### Linking point data to the road network

None of the address point data we source contain road network concordances, not even Openstreetmap!

In the image above you can see that the house numbers are not positioned exactly on the road network itself. It's very uncommon to find a house which sits exactly on the street, there is usually a sidewalk or driveway which offsets the distance from the road network.

#### Openstreetmap nodes

For this reason, the OSM entity tagged with `addr:housenumber` rarely shares a common node with the road network; moreover the building way rarely shares a common node with the road network:

| geometry | tags |
|:-:|:-:|
|![earls-court-51-node](/img/interpolation/earls-court-51-node.png) | ![earls-court-51-node](/img/interpolation/earls-court-51-node-tags.png) |
|![earls-court-51-way](/img/interpolation/earls-court-51-way.png) | ![earls-court-51-way](/img/interpolation/earls-court-51-way-tags.png) |

In order to group these street numbers with the road network to which they belong, we must use the same technique as discussed above:

Using a combination of spatial distance and linguistic similarity we can; with a degree of confidence; establish to which road segment the street number belongs to.

#### Openstreetmap ways

Similar to the above; except in this case the `addr:housenumber` tag has been applied to the way itself rather than a node:

| geometry | tags |
|:-:|:-:|
|![192-finborough-rd](/img/interpolation/192-finborough-rd.png) | ![192-finborough-rd](/img/interpolation/192-finborough-rd-tags.png) |

#### Openstreetmap interpolation lines

Openstreetmap contains invisible 'interpolation lines'; these ways group a range of addresses with a guide path which shows where the missing house numbers should lie:

| geometry | tags |
|:-:|:-:|
|![wetherby-mansions-way](/img/interpolation/wetherby-mansions-way.png) | ![wetherby-mansions-way](/img/interpolation/wetherby-mansions-way-tags.png) |
|![wetherby-mansions-node2](/img/interpolation/wetherby-mansions-node2.png) | ![wetherby-mansions-node2](/img/interpolation/wetherby-mansions-node2-tags.png) |
|![wetherby-mansions-node1](/img/interpolation/wetherby-mansions-node1.png) | ![wetherby-mansions-node1](/img/interpolation/wetherby-mansions-node1-tags.png) |

These lines can likely be processed after the nodes, if the nodes have already been associated to a road segment then that information can simply be copied to the interpolated address points.

#### Openaddresses and other point-only address datasets:

Other datasets which only contain point data can use the same process to create concordances between their house numbers and the road network:

![os-extract.png](/img/interpolation/oa-extract.png)
