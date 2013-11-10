# Pelias

OpenStreetMap + Elasticsearch 

## Overview

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
