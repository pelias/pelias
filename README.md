# Pelias

OpenStreetMap + Elasticsearch 

## Overview

Pelias is a set of tools for importing [OpenStreetMap](http://www.openstreetmap.org/) data into [Elasticsearch](http://www.elasticsearch.org/), and a simple server to handle queries and autocomplete suggestions.

## Requirements

First you need a postGIS-enabled PostgreSQL database with OpenStreetMap data, imported by [osm2pgsql](http://wiki.openstreetmap.org/wiki/Osm2pgsql).

Quattroshapes and Geonames are also required to build the index, as they provide the admin heirarchy. OpenStreetMap streets and address points are reverse geocoded into the admin heirarchy, and we ignore OpenStreetMap boundaries.

## Usage

    $ rake pelias:setup

    $ rake geonames:download
    $ rake geonames:populate

    $ rake quattroshapes:download
    $ rake quattroshapes:populate_local_admin
    $ rake quattroshapes:populate_localities
    $ rake quattroshapes:populate_neighborhoods
    $ rake quattroshapes:populate_gazetteer

    $ rake openstreetmap:populate_streets
    $ rake openstreetmap:populate_addresses
