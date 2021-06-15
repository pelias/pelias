
# Improved address discovery

This document dicusses address-range geocoding with Pelias in order to facilitate better address matching.

## Our values

Pelias is a modular, open-source geocoder built on top of ElasticSearch for fast geocoding.

In order to encourage external contribution *and* to ease the burden of installing and maintaining Pelias we made some early design decisions:

- It should be easy to install and require few external dependencies.
- It should be written in as few different programming languages as possible.

These decisions have kept the software modular; easy to install; maintain and contribute to over the years.

One of the compromises we made was not including a relational-database in our stack, if we required a PostgreSQL database containing an OpenStreetMap import, this would increase the complexity of installing, hosting and developing the software.

This would also not be in-line with our vision of commoditizing geocoding, it would add significant financial costs to host and require developer time to maintain and develop, additionally it would likely focus the product around OpenStreetMap and would likely result in the domain logic handled by a variety of different tools in different languages.

Javascript is the lingua franca of programming languages, we use it as much as possible, there are however one or two cases where we required another language to perform a specific task. In both cases [pbf2json](https://github.com/pelias/pbf2json) and [libpostal](https://github.com/openvenues/libpostal) have been wrapped in javascript bindings which required no external dependencies or compilers.

We also rely on data exports provided by external parties, for example: openstreetmap, openaddresses and geonames provide 'data dumps' which contributors may utilize in their installation. libpostal likewise provides 'builds' which we can pull down and utilize.

This separation of responsibility is core to our values, we consider it much more valuable to the community to have functionality externalized rather than internalized within a monolithic geocoding library.

### Address coverage

At time of writing we have ~285 million address points available to search from two different data sources:

| source | total address points |
|---|---|
| openstreetmap | ~45M |
| openaddresses | ~240M |

#### Openstreetmap

Openstreetmap is an excellent source of road network data, the coverage of street addresses is fairly complete in some countries such as Germany and the USA, however it is sparse in other countries.

There is an opportunity to increase the address points coverage provided by Openstreetmap by ~20M (estimate) using interpolation tags, this is covered later in this document; however it's clear that we will not be able to source a significant amount of global addresses from OSM.

#### Openaddresses

The amount of data being imported from `openaddresses` is still growing, it can increase by tens of millions of of addresses per month.

### Known issues

#### Street fallback

In the case where no matching address is found for a search, we should fall back to the road network in order to return more general information about the street in leiu of the actual address point.

We do not currently do this, if an exact address is not found, we simply attempt to return another address on the same street, if no addresses exist on the street we return nothing.

An example is [this road](http://www.openstreetmap.org/way/34243335) which has street geometry but does not have any address points available.

In this situation we cannot infer any numbering scheme or logically guess a number range so we will never be able to provide an exact house number.

Pelias does not currently import street geometry from Openstreetmap due to the large amount of duplicate/invalid names.

There is a [ticket](https://github.com/pelias/openstreetmap/issues/19) and a [repository](https://github.com/pelias/osm-featurelist-evaluation) dedicated to exploring the OSM features we bring in to Pelias, some extracts from that repo illustrate the issues with the data:

> Note: this data was taken from an NYC metro extract of records containing the highway:* tag

```
node	2708075964	Lamp Post
node	2708075965	Lamp Post
node	2708075966	Lamp Post
node	2708075967	Lamp Post
node	2708075970	Lamp Post
node	2708075974	Lamp Post
node	2708075976	Lamp Post
node	2708075977	Lamp Post
node	2708075979	Lamp Post
node	2708075981	Lamp Post
node	2708075982	Lamp Post
node	2708075983	Lamp Post
node	2708075984	Lamp Post
node	2708075988	Lamp Post
```

```
way	5709922	78th Street
way	5709923	78th Street
way	5709924	78th Street
way	5709925	78th Street
way	5709927	78th Street
way	5709928	78th Street
way	5709930	78th Street
way	5709931	78th Street
way	5709933	78th Street
way	5709934	78th Street
way	5709935	78th Street
way	5709936	78th Street
way	5709937	78th Street
way	5709938	78th Street
```

More examples: https://raw.githubusercontent.com/pelias/osm-featurelist-evaluation/master/cuts/highway.text

Importing this duplicate content would bloat the index and cause user experience problems.

The options of solving this issue are discussed later in this document in a section called 'clustering'.

#### Interpolation

In the case where we cannot find the exact house number *but* we know the street; we can attempt to 'infer' the position of the missing house number.

Interpolation is based on numeric 'ranges' of house numbers, it's not as precise as exact locations but can greatly increase the address coverage in the search engine.

![interpolation](/img/interpolation/tiger-interpolation-basics.png)

Interpolation can be complex due to the shape of the geometry, the offset from the road network, 'holes' in building ranges etc. This will be covered in more detail later in the document.

When discussing interpolation it's important to remember that although the position returned is inexact, the value to an automobile driver is still high, in most cases guiding a driver within a ~20m of their target will allow them to visually guide themselves the rest of their way to the destination.

Care must be taken in order to ensure that the destination point provided does not lie in a hazard. A naive linear interpolation between a group of points might center the destination point inside a building or water hazard, 'snapping' data to a road network should mitigate these issues.

This issue is discussed in more detail later in this document in a section called 'interpolation'.
