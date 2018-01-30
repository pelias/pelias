# Pelias

> A modular, open-source geocoder built on top of ElasticSearch for fast geocoding.

[![Gitter](https://badges.gitter.im/pelias/pelias.svg)](https://gitter.im/pelias/pelias?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

## Announcement: See our [update](https://github.com/pelias/pelias/tree/master/announcements/2018-01-02-pelias-update/) regarding the Mapzen shutdown

### What's a geocoder do anyway?

Geocoding is the process of transforming input text, such as an address, or a name of a place—to a location on the earth's surface.

![geocode](https://cloud.githubusercontent.com/assets/4246770/16500453/76d6d8cc-3eb9-11e6-85d8-f57894ba7b73.gif)

### ... and a reverse geocoder, what's that?

Reverse geocoding is the opposite: returning a list of places near a given point.

![reverse](https://cloud.githubusercontent.com/assets/4246770/16506005/a2429288-3ed4-11e6-8af0-7ef78824213f.gif)

### What makes Pelias different from other geocoders?

- It's completely open-source and MIT licensed
- It's based on open data, so you can run it yourself
- You can install it locally and modify it to suit your needs
- It has an impressive list of features, such as fast autocomplete
- It's modular, so you don't need to be an expert to make changes
- It's easy to install and requires no external dependencies
- We run a continuous deployment cycle with a new version shipping weekly

### What are the main goals of the Pelias project?

- Provide accurate search results
- Give users query suggestions (typeahead in the search box)
- Account for location bias (places nearer to you appear higher in the results)
- Support multiple data sources (the defaults are [OpenStreetMap](http://openstreetmap.org/), [OpenAddresses](http://openaddresses.io), [Geonames](http://geonames.org), and [Who's on First](https://www.whosonfirst.org/))
- Flexible software architecture
- Easy to contribute software patches and features to
- Easy to set up and configure your own instance
- No external dependencies (such as postgres)
- Reliable, configurable & fast import process
- Work equally well for a small city and the entire planet

### Developer Documentation & API Access

Sure! Our API lives at [search.mapzen.com](http://search.mapzen.com/), and is usable with an API key ([register here](https://mapzen.com/developers)) and generous
rate-limits. The endpoints are documented [here](https://mapzen.com/documentation/search); happy
geocoding!

[The Mapzen Search documentation](https://mapzen.com/documentation/search) also applies to standalone versions of Pelias, leaving aside API keys, privacy flags, and data sources which may be configured differently for other installations.

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

### How can I install my own instance of Pelias?

For a quick preview of what pelias is like, check out our [Vagrant development environment](https://github.com/pelias/vagrant).
Note that the Vagrant environment hasn't gotten a lot of updates lately, and it may not be working perfectly.

To do a _real_ installation of Pelias for production use or serious development, check out our [full installation docs](http://pelias.io/install.html).

### How does it work?

Magic! Well, like any geocoder, Pelias essentially combines [full text search](https://en.wikipedia.org/wiki/Full_text_search)
techniques with knowledge of geography to quickly search over many millions of records, each of which representing some sort of location on Earth.

The underlying architecture has three components:

  * **import pipelines**: the pipelines used to filter, normalize, and ingest geographic datasets into the Pelias database.
  * **database**: the underlying datastore that does all of the query heavy-lifting and powers our search results. We use
    [ElasticSearch](https://www.elastic.co/).
  * **API**: the thing that users interact with. A thin layer sitting on top of the datastore that implements additional
    logic and features.

Here's how they interact:

![A diagram of the Pelias architecture.](https://cloud.githubusercontent.com/assets/4467604/6944539/3b1cdd0e-d862-11e4-995d-0b376caacad6.png)

### What's it built with?
Pelias itself (the import pipelines and API) is written in [Node](https://nodejs.org/), which makes it highly
accessible for other developers and performant under heavy I/O. It aims to be modular and is distributed across a
number of Node packages, each with its own repository under the [Pelias GitHub
organization](https://github.com/pelias). ElasticSearch is our unconventional datastore of choice because of its
unparalleled text functionality, which makes text search *just work* right out of the box, and sufficiently robust
geospatial support.

### Contributing

We built Pelias as an open source project not just because we believe that users should be able to view and play with
the source code of tools they use, but to get the community involved in the project itself.

Anything that we can do to make contributing easier, we want to know about.  Feel free to reach out to us via Github,
[Gitter](https://gitter.im/pelias/pelias), [email](mailto:pelias.team@gmail.com), or [Twitter](https://twitter.com/mapzen)
 We'd love to help people get started working on Pelias, especially
if you're new to open source or programming in general. Both this [meta-repo](https://github.com/pelias/pelias/issues)
and the [API repo](https://github.com/pelias/api/issues) are good places to get started looking for tasks to tackle.
You can also look across all of our issues on our [meta-issue tracker](https://waffle.io/pelias/pelias), Waffle.
 We also welcome reporting issues or suggesting improvements to our [documentation](https://github.com/pelias/pelias-doc).

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
