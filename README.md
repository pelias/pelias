# Pelias

> A modular, open-source geocoder built on top of Elasticsearch for fast and accurate global search.

## Announcement: [Our third community call will be on Wednesday, June 27th](https://pelias.io/announcements/2018-06-19-community-call-3/). Join us!

### What's a geocoder do anyway?

Geocoding is the process of taking input text, such as an address or the name of a place, and returning a latitude/longitude location on the Earth's surface for that place.

![geocode](https://cloud.githubusercontent.com/assets/4246770/16500453/76d6d8cc-3eb9-11e6-85d8-f57894ba7b73.gif)

### ... and a reverse geocoder, what's that?

Reverse geocoding is the opposite: returning a list of places near a given latitude/longitude point.

![reverse](https://cloud.githubusercontent.com/assets/4246770/16506005/a2429288-3ed4-11e6-8af0-7ef78824213f.gif)

### What are the most interesting features of Pelias?

- Completely open-source and MIT licensed
- A powerful data import architecture: Pelias supports many open-data projects out of the box but also works great with private data
- Support for searching and displaying results in many languages
- Fast and accurate autocomplete for user-facing geocoding
- Support for many result types: addresses, venues, cities, countries, and more
- Modular design, so you don't need to be an expert in everything to make changes
- Easy installation with minimal external dependencies

### What are the main goals of the Pelias project?

- Provide accurate search results
- Work equally well for a small city and the entire planet
- Be highly configurable, so different use cases can be handled easily and efficiently
- Provide a friendly, welcoming, helpful community that takes input from people all over the world

### Where did Pelias come from?

Pelias was created in 2014 as an early project at [Mapzen](https://mapzen.com). After Mapzen's shutdown in 2017, Pelias is now [independent](https://github.com/pelias/pelias/tree/master/announcements/2018-01-02-pelias-update/).

### How does it work?

Magic! (Just kidding) Like any geocoder, Pelias combines [full text search](https://en.wikipedia.org/wiki/Full_text_search)
techniques with knowledge of geography to quickly search over many millions of records, each representing some sort of location on Earth.

The Pelias architecture has three main components and several smaller pieces.

![A diagram of the Pelias architecture.](https://raw.githubusercontent.com/pelias/pelias/master/img/Pelias%20Architecture.png)

#### Data importers

The importers filter, normalize, and ingest geographic datasets into the Pelias database. Currently there are five officially supported importers:

* **[OpenStreetMap](https://github.com/pelias/openstreetmap/)**: supports importing nodes and ways from [OpenStreetMap](http://openstreetmap.org/)
* **[OpenAddresses](https://github.com/pelias/openaddresses/)**: supports importing the hundreds of millions of global addresses collected from various authoritative government sources by [OpenAddresses](https://openaddresses.io/)
* **[Who's on First](https://github.com/pelias/whosonfirst/)**: supports importing admin areas and venues from [Who's on First](https://www.whosonfirst.org/)
* **[Geonames](https://github.com/pelias/geonames/)**: supports importing admin records and venues from [Geonames](http://www.geonames.org/)
* **[Polylines](https://github.com/pelias/polylines)**: supports any data in the [Google Polyline format](https://developers.google.com/maps/documentation/utilities/polylinealgorithm?csw=1). It's mainly used to import roads from OpenStreetMap

We are always discussing [supporting additional datasets](https://github.com/pelias/pelias/issues/254). Pelias users can also write their own importers, for example to import proprietary data into your own instance of Pelias.

#### Database
The underlying datastore that does most of the query heavy-lifting and powers our search results. We use [Elasticsearch](https://www.elastic.co/). Currently version 2.4 is supported, with [plans to support 5.x soon](https://github.com/pelias/pelias/issues/461).

We've built a tool called [pelias-schema](https://github.com/pelias/schema/) that sets up Elasticsearch indices properly for Pelias.

#### Frontend services

This is where the actual geocoding process happens, and includes the components that users interact with when performing geocoding queries. The services are:

  * **[API](https://github.com/pelias/api)**: The API service defines the Pelias API, and talks to Elasticsearch or other services as needed to perform queries.
  * **[Placeholder](https://github.com/pelias/placeholder)**: A service built specifically to capture the relationship between administrative areas (a catch-all term meaning anything like a city, state, country, etc). Elasticsearch does not handle relational data very well, so we built Placeholder specifically to manage this piece.
  * **[PIP](https://github.com/pelias/pip-service)**: For reverse geocoding, it's important to be able to perform [point-in-polygon](https://en.wikipedia.org/wiki/Point_in_polygon)(PIP) calculations quickly. The PIP service is the only component of Pelias that actually understands polygon geometries, and it is very good at quickly determining which admin area polygons a given point lies in.
  * **Libpostal**: Pelias uses the [libpostal](https://github.com/openvenues/libpostal) project for parsing addresses using the power of machine learning. Originally we loaded the 2GB of libpostal data directly in the API service, but this makes scaling harder and causes the API to take about 30 seconds to start, instead of a few milliseconds. We use a [Go service](https://github.com/whosonfirst/go-whosonfirst-libpostal) built by the Who's on First team to make this happen quickly and efficiently.
  * **[Interpolation](https://github.com/pelias/interpolation/)**: This service knows all about addresses and streets. With that knowledge, it is able to supplement the _known_ addresses that are stored directly in Elasticsearch and return fairly accurate _estimated_ address results for many more queries than would otherwise be possible.

#### Dependencies

These are software projects that are not used directly but are used by other components of Pelias.

There are lots of these, but here are some important ones:

* [model](https://github.com/pelias/model): provide a single library for creating documents that fit the Pelias Elasticsearch schema. This is a core component of our flexible importer architecture
* [wof-admin-lookup](https://github.com/pelias/wof-admin-lookup): A library for performing administrative lookup using point-in-polygon math. Previously included in each of the importers but now only used by the PIP service.
* [query](https://github.com/pelias/query): This is where most of our actual Elasticsearch query generation happens.
* [config](https://github.com/pelias/config): Pelias is very configurable, and all of it is driven from a single JSON file which we call `pelias.json`. This package provides a library for reading, validating, and working with this configuration. It is used by almost every other Pelias component
* [dbclient](https://github.com/pelias/dbclient): A Node.js stream library for quickly and efficiently importing records into Elasticsearch

#### Helpful tools

Finally, while not part of Pelias proper, we have built several useful tools for working with and testing Pelias

Notable examples include:

* [acceptance-tests](https://github.com/pelias/acceptance-tests): A Node.js command line tool for testing a full planet build of Pelias and ensuring everything works. Familiarity with this tool is very important for ensuring Pelias is working. It supports all Pelias features and has special facilities for testing autocomplete queries.
* [compare](https://github.com/pelias/compare): A web-based tool for comparing different instances of Pelias (for example a production and staging environment). We have a reference instance at [pelias.github.io/compare/](http://pelias.github.io/compare)
* [dashboard](https://github.com/pelias/dashboard): Another web-based tool for providing statistics about the contents of a Pelias Elasticsearch index such as import speed, number of total records, and a breakdown of records of various types.

### Documentation

The main documentation lives in the [pelias/documentation](https://github.com/pelias/documentation) repository.

Additionally, the README file in each of the component repositories listed above provides more detail on that piece.

<details>
  <summary>Here's an example API response for a reverse geocoding query</summary>

```javascript
$ curl -s "search.mapzen.com/v1/reverse?size=1&point.lat=40.74358294846026&point.lon=-73.99047374725342&api_key={YOUR_API_KEY}" | json
{
    "geocoding": {
        "attribution": "https://search.mapzen.com/v1/attribution",
        "engine": {
            "author": "Mapzen",
            "name": "Pelias",
            "version": "1.0"
        },
        "query": {
            "boundary.circle.lat": 40.74358294846026,
            "boundary.circle.lon": -73.99047374725342,
            "boundary.circle.radius": 500,
            "point.lat": 40.74358294846026,
            "point.lon": -73.99047374725342,
            "private": false,
            "querySize": 1,
            "size": 1
        },
        "timestamp": 1460736907438,
        "version": "0.1"
    },
    "type": "FeatureCollection",
    "features": [
        {
            "geometry": {
                "coordinates": [
                    -73.99051,
                    40.74361
                ],
                "type": "Point"
            },
            "properties": {
                "borough": "Manhattan",
                "borough_gid": "whosonfirst:borough:421205771",
                "confidence": 0.9,
                "country": "United States",
                "country_a": "USA",
                "country_gid": "whosonfirst:country:85633793",
                "county": "New York County",
                "county_gid": "whosonfirst:county:102081863",
                "distance": 0.004,
                "gid": "geonames:venue:9851011",
                "id": "9851011",
                "label": "Arlington, Manhattan, NY, USA",
                "layer": "venue",
                "locality": "New York",
                "locality_gid": "whosonfirst:locality:85977539",
                "name": "Arlington",
                "neighbourhood": "Flatiron District",
                "neighbourhood_gid": "whosonfirst:neighbourhood:85869245",
                "region": "New York",
                "region_a": "NY",
                "region_gid": "whosonfirst:region:85688543",
                "source": "geonames"
            },
            "type": "Feature"
        }
    ],
    "bbox": [
        -73.99051,
        40.74361,
        -73.99051,
        40.74361
    ]
}
```
</details>

### How can I install my own instance of Pelias?

To try out Pelias quickly, use our [Docker](https://github.com/pelias/docker/) setup. It uses Docker and docker-compose to allow you to quickly set up a Pelias instance for a small area (by default Portland, Oregon) in under 30 minutes.

To do a _real_ installation of Pelias for production use or serious development, read our [full installation docs](http://pelias.io/install.html).

### What's it built with?
Pelias itself (the import pipelines and API) is written in [Node.js](https://nodejs.org/), which makes it highly
accessible for other developers and performant under heavy I/O. It aims to be modular and is distributed across a
number of Node packages, each with its own repository under the [Pelias GitHub organization](https://github.com/pelias).

For a select few components that have performance requirements that Node.js cannot meet, we prefer to write things in [Go](https://golang.org/). A good example of this is the [pbf2json](https://github.com/pelias/pbf2json) tool that quickly converts OSM PBF files to JSON for our OSM importer.

Elasticsearch is our datastore of choice because of its unparalleled full text
search functionality, scalability, and sufficiently robust geospatial support.

### Contributing

[![Gitter](https://badges.gitter.im/pelias/pelias.svg)](https://gitter.im/pelias/pelias?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

We built Pelias as an open source project not just because we believe that users should be able to view and play with
the source code of tools they use, but to get the community involved in the project itself.

Especially with a geocoder with global coverage, it's just not possible for a small team to do it alone. We need you.

Anything that we can do to make contributing easier, we want to know about.  Feel free to reach out to us via Github,
[Gitter](https://gitter.im/pelias/pelias), [email](mailto:pelias.team@gmail.com), or [Twitter](https://twitter.com/pelias_geocoder)
 We'd love to help people get started working on Pelias, especially if you're
 new to open source or programming in general.

Both this [meta-repo](https://github.com/pelias/pelias/issues) and the [API service repo](https://github.com/pelias/api/issues) are good places to get started
looking for tasks to tackle.  You can also look across all of our issues on our [meta-issue tracker](https://waffle.io/pelias/pelias), Waffle.  We also welcome
reporting issues or suggesting improvements to our [documentation](https://github.com/pelias/documentation).

The current Pelias team can be found on Github as [dianashk](https://github.com/dianashk),
[missinglink](https://github.com/missinglink), [orangejulius](https://github.com/orangejulius), and [trescube](https://github.com/trescube).

Members emeritus include:
* [randyme](https://github.com/randyme)
* [seejohnrun](https://github.com/seejohnrun)
* [fdansv](http://github.com/fdansv)
* [sevko](https://github.com/sevko)
* [hkrishna](https://github.com/hkrishna)
* [riordan](https://github.com/riordan)
* [avulfson17](https://github.com/avulfson17)
* [tigerlily-he](https://github.com/tigerlily-he)
