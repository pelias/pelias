# Pelias

[![Build Status][travis-pelias-png]][travis-pelias]

Pelias is a set of tools for importing [OpenStreetMap](http://www.openstreetmap.org/) data into [Elasticsearch](http://www.elasticsearch.org/), and a simple server to handle queries and autocomplete suggestions.

## Requirements

* PostgreSQL: You'll need a postGIS-enabled database with OpenStreetMap data, imported with [osm2pgsql](http://wiki.openstreetmap.org/wiki/Osm2pgsql). The import process expects certain fields, so you'll need to use the style file here: config/osm2pgsql.style
* Elasticsearch: Download and run the latest version of [Elasticsearch](http://www.elasticsearch.org/download/). This was built on version 0.90.8 and requires at least 0.90.3.
* Redis: Install Redis in order to process background jobs during the indexing process.
* Sidekiq: Used for background processing, you'll need to set up the background workers and optional web monitoring interface. Info [here](http://sidekiq.org/).

[Quattroshapes](http://quattroshapes.com/) and [Geonames](http://www.geonames.org/) are also required to build the index, as they provide the admin heirarchy. You can download those via the rake tasks below. OpenStreetMap streets and address points are reverse geocoded into the admin heirarchy, and we ignore OpenStreetMap boundaries at the moment.

## Usage

To get set up, run the following.

### Set up the index & mappings:

    $ rake index:create

### Prepare Quattroshapes shapefiles and load them into ElasticSearch:

    $ rake quattroshapes:prepare_all
    $ rake quattroshapes:populate_all

### Download geonames, and add them to the index.

This provides nicer names, alternate names, and populations (which factor into autocomplete weights).

    $ rake geonames:populate

### Add OSM data

Assuming you've set up a postGIS-enabled database with OSM data, the following will add all streets and addresses to the index, reverse geocoding them into the above shapes. This should capture most of the streets and addresses in OSM, but is probably missing some. It's not as exhaustive as Nominatim at this point.

    $ rake osm:populate_streets
    $ rake osm:populate_addresses

## Start the server

    $ unicorn

You should now be able to access the server at http://localhost:8080/suggest?query=bro

## Production-like Setup Performance Information

To give you an idea of what you're getting into, we provide the following synopsis of an environment purpose built for the loading of this data. In addition, rough times to complete each step, along with what the end product will look like in terms of amount of data, number of documents, etc.

### Architecture/Tuning

* PostgreSQL/PostGIS: 1 c3.8xlarge
* Elasticsearch: 4 c3.4xlarge
* Sidekiq: 4 c1.medium

Using this hardware allocation, we also recommend the following during the initial data load:
* disable replication in elasticsearch: `curl -s -XPUT http://localhost:9200/_settings -d "{\"index\": {\"number_of_replicas\" : \"0\"}}"`
* set the index refresh interval to something north of 60 seconds: `curl -s -XPUT http://localhost:9200/_settings -d "{\"index\": {\"refresh_interval\" : \"3600s\"}}"`
* in PostgreSQL, add the following index (this will take some time if you're working with a full planet installation): `CREATE INDEX limit_street_line ON planet_osm_line (name, highway);`

### Load Times

Using the above architecture, we've observed the following load times:
* `rake quattroshapes:populate_all`
* `rake quattroshapes:prepare_all` ~ 1.5 hours. Load on Elasticsearch is generally near 100% CPU with a 5 minute load average of 14 (the c3.4xlarge instances provide 16 cores)
* `rake geonames:populate`
* `rake osm:populate_streets`
* `rake osm:populate_addresses`

## API

Right now there are two endpoints: /suggest (which is awesome) and /search (which needs work). All results are in GeoJSON.

Examples:

* [http://pelias.test.mapzen.com/suggest?query=bro](http://pelias.test.mapzen.com/suggest?query=bro)
* [http://pelias.test.mapzen.com/suggest?query=bro&size=5](http://pelias.test.mapzen.com/suggest?query=bro&size=5)
* [http://pelias.test.mapzen.com/search?query=brooklyn](http://pelias.test.mapzen.com/search?query=brooklyn)
* [http://pelias.test.mapzen.com/search?query=brooklyn&center=-74.08,40.77](http://pelias.test.mapzen.com/search?query=brooklyn&center=-74.08,40.77)
* [http://pelias.test.mapzen.com/search?query=brooklyn&viewbox=-74.08,40.77,-73.9,40.67](http://pelias.test.mapzen.com/search?query=brooklyn&viewbox=-74.08,40.77,-73.9,40.67)
* [http://pelias.test.mapzen.com/search?query=brooklyn&viewbox=-74.08,40.77,-73.9,40.67&center=-74.08,40.77](http://pelias.test.mapzen.com/search?query=brooklyn&viewbox=-74.08,40.77,-73.9,40.67&center=-74.08,40.77)

## Demo

Check out our demo here: [http://mapzen.com/pelias](http://mapzen.com/pelias)
