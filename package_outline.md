# ![](https://avatars.githubusercontent.com/u/8240367?v=3) Pelias Packages
Table of contents:

  [pelias-openstreetmap](#pelias-openstreetmap)
<br/>
  [pelias-addresses](#pelias-addresses)
<br/>
  [pelias-openaddresses](#pelias-openaddresses)
<br/>
  [pelias-geonames](#pelias-geonames)
<br/>
  [pelias-api](#pelias-api)
<br/>
  [pelias-quattroshapes](#pelias-quattroshapes)
<br/>
  [whosonfirst](#whosonfirst)
<br/>
  [pelias-tiger](#pelias-tiger)
<br/>
  [fences](#fences)
<br/>
  [osm-featurelist-evaluation](#osm-featurelist-evaluation)
<br/>
  [pelias-fuzzy-tests](#pelias-fuzzy-tests)
<br/>
  [pelias-acceptance-tests](#pelias-acceptance-tests)
<br/>
  [pelias-webview](#pelias-webview)
<br/>
  [tools](#tools)
<br/>
  [pelias-loadtest](#pelias-loadtest)
<br/>
  [geocode-node](#geocode-node)
<br/>
  [pelias-batch-search](#pelias-batch-search)
<br/>
  [pelias-wof-regioncode-lookup](#pelias-wof-regioncode-lookup)
<br/>
  [feedback](#feedback)
<br/>
  [pelias-init](#pelias-init)
<br/>
  [pbf-parser-comparison](#pbf-parser-comparison)
<br/>
  [pelias-wof-countrycode-lookup](#pelias-wof-countrycode-lookup)
<br/>
  [pelias-cli](#pelias-cli)
<br/>
  [pelias-playground](#pelias-playground)
<br/>
  [pelias-leaflet-geocoder](#pelias-leaflet-geocoder)
<br/>
  [mapzen-search-team-ownership](#mapzen-search-team-ownership)
<br/>
  [pelias-regression-tests](#pelias-regression-tests)
<br/>
--------



### [`pelias-openstreetmap`](https://github.com/pelias/openstreetmap)

[![Build Status](https://travis-ci.org/pelias/openstreetmap.svg?branch=master)](https://travis-ci.org/pelias/openstreetmap)

_Pelias openstreetmap utilities_

[![NPM](https://nodei.co/npm/pelias-openstreetmap.png?downloads=true&stars=true)](https://nodei.co/npm/pelias-openstreetmap)

 * [`pbf2json`](https://github.com/pelias/pbf2json)    [![Build Status](https://travis-ci.org/pelias/pbf2json.svg?branch=master)](https://travis-ci.org/pelias/pbf2json)
 * [`pelias-address-deduplicator`](https://github.com/pelias/address-deduplicator)    [![Build Status](https://travis-ci.org/pelias/address-deduplicator.svg?branch=master)](https://travis-ci.org/pelias/address-deduplicator)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
   * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-dbclient`](https://github.com/pelias/dbclient)    [![Build Status](https://travis-ci.org/pelias/dbclient.svg?branch=master)](https://travis-ci.org/pelias/dbclient)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-model`](https://github.com/pelias/model)    [![Build Status](https://travis-ci.org/pelias/model.svg?branch=master)](https://travis-ci.org/pelias/model)
 * [`pelias-wof-admin-lookup`](https://github.com/pelias/wof-admin-lookup)    [![Build Status](https://travis-ci.org/pelias/wof-admin-lookup.svg?branch=master)](https://travis-ci.org/pelias/wof-admin-lookup)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-parallel-stream`](https://github.com/pelias/parallel-stream)    [![Build Status](https://travis-ci.org/pelias/parallel-stream.svg?branch=master)](https://travis-ci.org/pelias/parallel-stream)
   * [`pelias-wof-pip-service`](https://github.com/pelias/wof-pip-service)    [![Build Status](https://travis-ci.org/pelias/wof-pip-service.svg?branch=master)](https://travis-ci.org/pelias/wof-pip-service)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
     * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
       * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
         * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
     * [`polygon-lookup`](https://github.com/pelias/polygon-lookup)    [![Build Status](https://travis-ci.org/pelias/polygon-lookup.svg?branch=master)](https://travis-ci.org/pelias/polygon-lookup)


<br/>
-----


### [`pelias-addresses`](https://github.com/pelias/addresses)

[![Build Status](https://travis-ci.org/pelias/addresses.svg?branch=master)](https://travis-ci.org/pelias/addresses)

_Mapzen addresses pipeline for generating a high-quality dump of global addresses._

[![NPM](https://nodei.co/npm/pelias-addresses.png?downloads=true&stars=true)](https://nodei.co/npm/pelias-addresses)

 * [`line-interpolate-points`](https://github.com/pelias/line-interpolate-points)    [![Build Status](https://travis-ci.org/pelias/line-interpolate-points.svg?branch=master)](https://travis-ci.org/pelias/line-interpolate-points)
 * [`schema-mapper`](https://github.com/pelias/schema-mapper)    [![Build Status](https://travis-ci.org/pelias/schema-mapper.svg?branch=master)](https://travis-ci.org/pelias/schema-mapper)
 * [`prop-stream`](https://github.com/pelias/prop-stream)    [![Build Status](https://travis-ci.org/pelias/prop-stream.svg?branch=master)](https://travis-ci.org/pelias/prop-stream)
 * [`pelias-schema`](https://github.com/pelias/schema)    [![Build Status](https://travis-ci.org/pelias/schema.svg?branch=master)](https://travis-ci.org/pelias/schema)
   * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-suggester-pipeline`](https://github.com/pelias/suggester-pipeline)    [![Build Status](https://travis-ci.org/pelias/suggester-pipeline.svg?branch=master)](https://travis-ci.org/pelias/suggester-pipeline)
 * [`pelias-dbclient`](https://github.com/pelias/dbclient)    [![Build Status](https://travis-ci.org/pelias/dbclient.svg?branch=master)](https://travis-ci.org/pelias/dbclient)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-model`](https://github.com/pelias/model)    [![Build Status](https://travis-ci.org/pelias/model.svg?branch=master)](https://travis-ci.org/pelias/model)


<br/>
-----


### [`pelias-openaddresses`](https://github.com/pelias/openaddresses)

[![Build Status](https://travis-ci.org/pelias/openaddresses.svg?branch=master)](https://travis-ci.org/pelias/openaddresses)

_Pelias import pipeline for OpenAddresses._

[![NPM](https://nodei.co/npm/pelias-openaddresses.png?downloads=true&stars=true)](https://nodei.co/npm/pelias-openaddresses)

 * [`pelias-address-deduplicator`](https://github.com/pelias/address-deduplicator)    [![Build Status](https://travis-ci.org/pelias/address-deduplicator.svg?branch=master)](https://travis-ci.org/pelias/address-deduplicator)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
   * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-dbclient`](https://github.com/pelias/dbclient)    [![Build Status](https://travis-ci.org/pelias/dbclient.svg?branch=master)](https://travis-ci.org/pelias/dbclient)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-model`](https://github.com/pelias/model)    [![Build Status](https://travis-ci.org/pelias/model.svg?branch=master)](https://travis-ci.org/pelias/model)
 * [`pelias-wof-admin-lookup`](https://github.com/pelias/wof-admin-lookup)    [![Build Status](https://travis-ci.org/pelias/wof-admin-lookup.svg?branch=master)](https://travis-ci.org/pelias/wof-admin-lookup)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-parallel-stream`](https://github.com/pelias/parallel-stream)    [![Build Status](https://travis-ci.org/pelias/parallel-stream.svg?branch=master)](https://travis-ci.org/pelias/parallel-stream)
   * [`pelias-wof-pip-service`](https://github.com/pelias/wof-pip-service)    [![Build Status](https://travis-ci.org/pelias/wof-pip-service.svg?branch=master)](https://travis-ci.org/pelias/wof-pip-service)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
     * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
       * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
         * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
     * [`polygon-lookup`](https://github.com/pelias/polygon-lookup)    [![Build Status](https://travis-ci.org/pelias/polygon-lookup.svg?branch=master)](https://travis-ci.org/pelias/polygon-lookup)


<br/>
-----


### [`pelias-geonames`](https://github.com/pelias/geonames)

[![Build Status](https://travis-ci.org/pelias/geonames.svg?branch=master)](https://travis-ci.org/pelias/geonames)

_Open-source geo-coder & reverse geo-coder_

[![NPM](https://nodei.co/npm/pelias-geonames.png?downloads=true&stars=true)](https://nodei.co/npm/pelias-geonames)

 * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
   * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-dbclient`](https://github.com/pelias/dbclient)    [![Build Status](https://travis-ci.org/pelias/dbclient.svg?branch=master)](https://travis-ci.org/pelias/dbclient)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-model`](https://github.com/pelias/model)    [![Build Status](https://travis-ci.org/pelias/model.svg?branch=master)](https://travis-ci.org/pelias/model)
 * [`pelias-wof-admin-lookup`](https://github.com/pelias/wof-admin-lookup)    [![Build Status](https://travis-ci.org/pelias/wof-admin-lookup.svg?branch=master)](https://travis-ci.org/pelias/wof-admin-lookup)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-parallel-stream`](https://github.com/pelias/parallel-stream)    [![Build Status](https://travis-ci.org/pelias/parallel-stream.svg?branch=master)](https://travis-ci.org/pelias/parallel-stream)
   * [`pelias-wof-pip-service`](https://github.com/pelias/wof-pip-service)    [![Build Status](https://travis-ci.org/pelias/wof-pip-service.svg?branch=master)](https://travis-ci.org/pelias/wof-pip-service)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
     * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
       * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
         * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
     * [`polygon-lookup`](https://github.com/pelias/polygon-lookup)    [![Build Status](https://travis-ci.org/pelias/polygon-lookup.svg?branch=master)](https://travis-ci.org/pelias/polygon-lookup)


<br/>
-----


### [`pelias-api`](https://github.com/pelias/api)

[![Build Status](https://travis-ci.org/pelias/api.svg?branch=master)](https://travis-ci.org/pelias/api)

_Pelias API_

[![NPM](https://nodei.co/npm/pelias-api.png?downloads=true&stars=true)](https://nodei.co/npm/pelias-api)

 * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
   * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-model`](https://github.com/pelias/model)    [![Build Status](https://travis-ci.org/pelias/model.svg?branch=master)](https://travis-ci.org/pelias/model)
 * [`pelias-query`](https://github.com/pelias/query)    [![Build Status](https://travis-ci.org/pelias/query.svg?branch=master)](https://travis-ci.org/pelias/query)
 * [`pelias-suggester-pipeline`](https://github.com/pelias/suggester-pipeline)    [![Build Status](https://travis-ci.org/pelias/suggester-pipeline.svg?branch=master)](https://travis-ci.org/pelias/suggester-pipeline)


<br/>
-----


### [`pelias-quattroshapes`](https://github.com/pelias/quattroshapes)



_no description_

[![NPM](https://nodei.co/npm/pelias-quattroshapes.png?downloads=true&stars=true)](https://nodei.co/npm/pelias-quattroshapes)

 * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
   * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-dbclient`](https://github.com/pelias/dbclient)    [![Build Status](https://travis-ci.org/pelias/dbclient.svg?branch=master)](https://travis-ci.org/pelias/dbclient)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-schema`](https://github.com/pelias/schema)    [![Build Status](https://travis-ci.org/pelias/schema.svg?branch=master)](https://travis-ci.org/pelias/schema)
   * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-admin-lookup`](https://github.com/pelias/admin-lookup)    [![Build Status](https://travis-ci.org/pelias/admin-lookup.svg?branch=master)](https://travis-ci.org/pelias/admin-lookup)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`polygon-lookup`](https://github.com/pelias/polygon-lookup)    [![Build Status](https://travis-ci.org/pelias/polygon-lookup.svg?branch=master)](https://travis-ci.org/pelias/polygon-lookup)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`prop-stream`](https://github.com/pelias/prop-stream)    [![Build Status](https://travis-ci.org/pelias/prop-stream.svg?branch=master)](https://travis-ci.org/pelias/prop-stream)


<br/>
-----


### [`whosonfirst`](https://github.com/pelias/whosonfirst)

[![Build Status](https://travis-ci.org/pelias/whosonfirst.svg?branch=master)](https://travis-ci.org/pelias/whosonfirst)

_Importer for Who's on First_

 * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
   * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-dbclient`](https://github.com/pelias/dbclient)    [![Build Status](https://travis-ci.org/pelias/dbclient.svg?branch=master)](https://travis-ci.org/pelias/dbclient)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-model`](https://github.com/pelias/model)    [![Build Status](https://travis-ci.org/pelias/model.svg?branch=master)](https://travis-ci.org/pelias/model)


<br/>
-----


### [`pelias-tiger`](https://github.com/pelias/tiger)



_A pipeline for importing TIGER data into Pelias._

 * [`pelias-dbclient`](https://github.com/pelias/dbclient)    [![Build Status](https://travis-ci.org/pelias/dbclient.svg?branch=master)](https://travis-ci.org/pelias/dbclient)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-suggester-pipeline`](https://github.com/pelias/suggester-pipeline)    [![Build Status](https://travis-ci.org/pelias/suggester-pipeline.svg?branch=master)](https://travis-ci.org/pelias/suggester-pipeline)
 * [`line-interpolate-points`](https://github.com/pelias/line-interpolate-points)    [![Build Status](https://travis-ci.org/pelias/line-interpolate-points.svg?branch=master)](https://travis-ci.org/pelias/line-interpolate-points)
 * [`pelias-model`](https://github.com/pelias/model)    [![Build Status](https://travis-ci.org/pelias/model.svg?branch=master)](https://travis-ci.org/pelias/model)


<br/>
-----


### [`fences`](https://github.com/pelias/fences-cli)

[![Build Status](https://travis-ci.org/pelias/fences-cli.svg?branch=master)](https://travis-ci.org/pelias/fences-cli)

_Builds administrative boundary datasets_

[![NPM](https://nodei.co/npm/fences.png?downloads=true&stars=true)](https://nodei.co/npm/fences)

 * [`fences-builder`](https://github.com/pelias/fences-builder)    [![Build Status](https://travis-ci.org/pelias/fences-builder.svg?branch=master)](https://travis-ci.org/pelias/fences-builder)
 * [`fences-slicer`](https://github.com/pelias/fences-slicer)    [![Build Status](https://travis-ci.org/pelias/fences-slicer.svg?branch=master)](https://travis-ci.org/pelias/fences-slicer)
   * [`polygon-lookup`](https://github.com/pelias/polygon-lookup)    [![Build Status](https://travis-ci.org/pelias/polygon-lookup.svg?branch=master)](https://travis-ci.org/pelias/polygon-lookup)


<br/>
-----


### [`osm-featurelist-evaluation`](https://github.com/pelias/osm-featurelist-evaluation)



_no description_

 * [`pbf2json`](https://github.com/pelias/pbf2json)    [![Build Status](https://travis-ci.org/pelias/pbf2json.svg?branch=master)](https://travis-ci.org/pelias/pbf2json)


<br/>
-----


### [`pelias-fuzzy-tests`](https://github.com/pelias/fuzzy-tests)

[![Build Status](https://travis-ci.org/pelias/fuzzy-tests.svg?branch=master)](https://travis-ci.org/pelias/fuzzy-tests)

_Fuzzy tests for Pelias Geocoder API_

 * [`pelias-fuzzy-tester`](https://github.com/pelias/fuzzy-tester)    [![Build Status](https://travis-ci.org/pelias/fuzzy-tester.svg?branch=master)](https://travis-ci.org/pelias/fuzzy-tester)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)


<br/>
-----


### [`pelias-acceptance-tests`](https://github.com/pelias/acceptance-tests)



_Acceptance tests for Pelias Geocoder API_

 * [`pelias-fuzzy-tester`](https://github.com/pelias/fuzzy-tester)    [![Build Status](https://travis-ci.org/pelias/fuzzy-tester.svg?branch=master)](https://travis-ci.org/pelias/fuzzy-tester)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)


<br/>
-----


### [`pelias-webview`](https://github.com/pelias/dash)



_Pelias web view_

 * [`pelias-esclient`](https://github.com/pelias/esclient)    [![Build Status](https://travis-ci.org/pelias/esclient.svg?branch=master)](https://travis-ci.org/pelias/esclient)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)


<br/>
-----


### [`tools`](https://github.com/pelias/locmux)



_no description_

[![NPM](https://nodei.co/npm/tools.png?downloads=true&stars=true)](https://nodei.co/npm/tools)

no dependencies

<br/>
-----


### [`pelias-loadtest`](https://github.com/pelias/loadtest)



_Load testing scripts for Pelias_

no dependencies

<br/>
-----


### [`geocode-node`](https://github.com/pelias/geocoder-test)



_no description_

no dependencies

<br/>
-----


### [`pelias-batch-search`](https://github.com/pelias/scripts-batch-search)



_Simple csv batch geocoding utility_

no dependencies

<br/>
-----


### [`pelias-wof-regioncode-lookup`](https://github.com/pelias/wof-regioncode-lookup)



_This project exposes a stream that will modify pelias Document objects to include a region code. It is a temporary project that will last until Who's on First supports 2 character region codes._

no dependencies

<br/>
-----


### [`feedback`](https://github.com/pelias/feedback)



_no description_

[![NPM](https://nodei.co/npm/feedback.png?downloads=true&stars=true)](https://nodei.co/npm/feedback)

no dependencies

<br/>
-----


### [`pelias-init`](https://github.com/pelias/init)



_A CLI tool for initializing new Pelias projects._

[![NPM](https://nodei.co/npm/pelias-init.png?downloads=true&stars=true)](https://nodei.co/npm/pelias-init)

no dependencies

<br/>
-----


### [`pbf-parser-comparison`](https://github.com/pelias/pbf-parser-comparison)



_no description_

no dependencies

<br/>
-----


### [`pelias-wof-countrycode-lookup`](https://github.com/pelias/wof-countrycode-lookup)



_This project exposes a stream that will modify pelias Document objects to include a country code. It is a temporary project that will last until Who's on First PiP server supports 3 character country codes._

no dependencies

<br/>
-----


### [`pelias-cli`](https://github.com/pelias/cli)



_The Pelias command-line power tool._

[![NPM](https://nodei.co/npm/pelias-cli.png?downloads=true&stars=true)](https://nodei.co/npm/pelias-cli)

no dependencies

<br/>
-----


### [`pelias-playground`](https://github.com/pelias/playground)



_no description_

no dependencies

<br/>
-----


### [`pelias-leaflet-geocoder`](https://github.com/pelias/leaflet-geocoder)



_Leaflet plugin to search (geocode) using Mapzen Search or your own hosted version of the Pelias Geocoder API._

[![NPM](https://nodei.co/npm/pelias-leaflet-geocoder.png?downloads=true&stars=true)](https://nodei.co/npm/pelias-leaflet-geocoder)

no dependencies

<br/>
-----


### [`mapzen-search-team-ownership`](https://github.com/pelias/ownership)



_manage npm owner status in bulk_

[![NPM](https://nodei.co/npm/mapzen-search-team-ownership.png?downloads=true&stars=true)](https://nodei.co/npm/mapzen-search-team-ownership)

no dependencies

<br/>
-----


### [`pelias-regression-tests`](https://github.com/pelias/regression-tests)

[![Build Status](https://travis-ci.org/pelias/regression-tests.svg?branch=master)](https://travis-ci.org/pelias/regression-tests)

_Pelias regression-tests suite_

no dependencies

<br/>
-----


