# Pelias

OpenStreetMap + Elasticsearch 

## Overview

Pelias is a set of tools for importing [OpenStreetMap](http://www.openstreetmap.org/) data into [Elasticsearch](http://www.elasticsearch.org/), and a simple server to handle queries and autocomplete suggestions.

## Requirements

First you need a postGIS-enabled PostgreSQL database with OpenStreetMap data, imported by [osm2pgsql](http://wiki.openstreetmap.org/wiki/Osm2pgsql).

Quattroshapes and Geonames are also required to build the index, as they provide the admin heirarchy. OpenStreetMap streets and address points are reverse geocoded into the admin heirarchy, and we ignore OpenStreetMap boundaries.

## Usage

First set up the OpenStreetMap index for streets and addresses:

    $ rake openstreetmap:setup
    $ rake openstreetmap:populate_streets
    $ rake openstreetmap:populate_addresses

Then the Geonames index:

    $ rake geonames:setup
    $ rake geonames:populate_features

Then Zetashapes, which depends on the Geonames index above:

    $ rake zetashapes:setup
    $ rake zetashapes:populate_localities
    $ rake zetashapes:populate_neighborhoods

Finally the Pelias index, which will reverse geocode the OpenStreetMap addresses and streets into the quattroshapes above.

    $ rake pelias:setup
    $ rake pelias:build_index
