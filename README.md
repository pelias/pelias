# Pelias

Pelias is a set of tools for importing [OpenStreetMap](http://www.openstreetmap.org/) data into [Elasticsearch](http://www.elasticsearch.org/), and a simple server to handle queries and autocomplete suggestions.

## Requirements

* PostgreSQL: You'll need a postGIS-enabled database with OpenStreetMap data, imported with [osm2pgsql](http://wiki.openstreetmap.org/wiki/Osm2pgsql). The import process expects certain fields, so you'll need to use the style file here: lib/pelias/config/osm2pgsql.style
* Elasticsearch: Download and run the latest version of [Elasticsearch](http://www.elasticsearch.org/download/). This was built on version 0.90.8 and requires at least 0.90.3.
* Redis: Install Redis in order to process background jobs during the indexing process.
* Sidekiq: Used for background processing, you'll need to set up the background workers and optional web monitoring interface. Info [here](http://sidekiq.org/).

[Quattroshapes](http://quattroshapes.com/) and [Geonames](http://www.geonames.org/) are also required to build the index, as they provide the admin heirarchy. You can download those via the rake tasks below. OpenStreetMap streets and address points are reverse geocoded into the admin heirarchy, and we ignore OpenStreetMap boundaries at the moment.

## Usage

To get set up, run the following. Order is important!

Set up the index & mappings:

    $ rake pelias:setup

Download geonames, and add them to the index. This provides part of the admin heirarchy. They're also used for populations (which factor into autocomplete weights) and alternate names.

    $ rake geonames:download
    $ rake geonames:populate

Download & unzip Quattroshapes shapefiles. We only index these if we can find a relevant Geoname above!

    $ rake quattroshapes:download
    $ rake quattroshapes:populate_admin2
    $ rake quattroshapes:populate_local_admin
    $ rake quattroshapes:populate_localities
    $ rake quattroshapes:populate_neighborhoods

Assuming you've set up a postGIS-enabled database with OSM data, the following will add all streets and addresses to the index, reverse geocoding them into the above shapes. This should capture most of the streets and addresses in OSM, but is probably missing some. It's not as exhaustive as Nominatim at this point.

    $ rake openstreetmap:populate_streets
    $ rake openstreetmap:populate_addresses

To run the test server:

    $ bundle console
    > Server.run!

You should be able to access the server at http://localhost:4567/demo

## API

Right now there are two endpoints: /suggest (which is awesome) and /search (which needs work). All results are in GeoJSON.

Examples:

* [http://api-pelias-test.mapzen.com/suggest?query=bro](http://api-pelias-test.mapzen.com/suggest?query=bro)
* [http://api-pelias-test.mapzen.com/suggest?query=bro&size=5](http://api-pelias-test.mapzen.com/suggest?query=bro&size=5)
* [http://api-pelias-test.mapzen.com/search?query=brooklyn](http://api-pelias-test.mapzen.com/search?query=brooklyn)
* [http://api-pelias-test.mapzen.com/search?query=brooklyn&center=-74.08,40.77](http://api-pelias-test.mapzen.com/search?query=brooklyn&center=-74.08,40.77)
* [http://api-pelias-test.mapzen.com/search?query=brooklyn&viewbox=-74.08,40.77,-73.9,40.67](http://api-pelias-test.mapzen.com/search?query=brooklyn&viewbox=-74.08,40.77,-73.9,40.67)
* [http://api-pelias-test.mapzen.com/search?query=brooklyn&viewbox=-74.08,40.77,-73.9,40.67&center=-74.08,40.77](http://api-pelias-test.mapzen.com/search?query=brooklyn&viewbox=-74.08,40.77,-73.9,40.67&center=-74.08,40.77)

## Demo

Check out our demo here: [http://api-pelias-test.mapzen.com/demo](http://api-pelias-test.mapzen.com/demo)
