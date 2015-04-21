# ![](https://avatars.githubusercontent.com/u/8240367?v=3) Pelias packages
Table of contents:

  [pelias-openaddresses](#pelias-openaddresses)
<br/>
  [pelias-addresses](#pelias-addresses)
<br/>
  [quattroshapes](#quattroshapes)
<br/>
  [pelias-geonames](#pelias-geonames)
<br/>
  [pelias-openstreetmap](#pelias-openstreetmap)
<br/>
  [pelias-tiger](#pelias-tiger)
<br/>
  [pelias-api](#pelias-api)
<br/>
  [fences](#fences)
<br/>
  [pelias-webview](#pelias-webview)
<br/>
  [pelias-quattroshapes](#pelias-quattroshapes)
<br/>
  [pelias-acceptance-tests](#pelias-acceptance-tests)
<br/>
  [pbf-parser-comparison](#pbf-parser-comparison)
<br/>
  [feedback](#feedback)
<br/>
  [pelias-init](#pelias-init)
<br/>
  [pelias-regression-tests](#pelias-regression-tests)
<br/>
  [mapzen-search-team-ownership](#mapzen-search-team-ownership)
<br/>
--------



### [`pelias-openaddresses`](https://github.com/pelias/openaddresses)

[![Build Status](https://travis-ci.org/pelias/openaddresses.svg?branch=master)](https://travis-ci.org/pelias/openaddresses)

_Pelias import pipeline for OpenAddresses._

[![NPM](https://nodei.co/npm/pelias-openaddresses.png?downloads=true&stars=true)](https://nodei.co/npm/pelias-openaddresses)

 * [`pelias-address-deduplicator`](https://github.com/pelias/address-deduplicator)    
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-model`](https://github.com/pelias/model)    [![Build Status](https://travis-ci.org/pelias/model.svg?branch=master)](https://travis-ci.org/pelias/model)
 * [`pelias-dbclient`](https://github.com/pelias/dbclient)    [![Build Status](https://travis-ci.org/pelias/dbclient.svg?branch=master)](https://travis-ci.org/pelias/dbclient)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-suggester-pipeline`](https://github.com/pelias/suggester-pipeline)    [![Build Status](https://travis-ci.org/pelias/suggester-pipeline.svg?branch=master)](https://travis-ci.org/pelias/suggester-pipeline)
 * [`pelias-admin-lookup`](https://github.com/pelias/admin-lookup)    [![Build Status](https://travis-ci.org/pelias/admin-lookup.svg?branch=master)](https://travis-ci.org/pelias/admin-lookup)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`polygon-lookup`](https://github.com/pelias/polygon-lookup)    [![Build Status](https://travis-ci.org/pelias/polygon-lookup.svg?branch=master)](https://travis-ci.org/pelias/polygon-lookup)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
   * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)


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


### [`quattroshapes`](https://github.com/pelias/quattroshapes)



_no description_

[![NPM](https://nodei.co/npm/quattroshapes.png?downloads=true&stars=true)](https://nodei.co/npm/quattroshapes)

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
 * [`pelias-suggester-pipeline`](https://github.com/pelias/suggester-pipeline)    [![Build Status](https://travis-ci.org/pelias/suggester-pipeline.svg?branch=master)](https://travis-ci.org/pelias/suggester-pipeline)
 * [`prop-stream`](https://github.com/pelias/prop-stream)    [![Build Status](https://travis-ci.org/pelias/prop-stream.svg?branch=master)](https://travis-ci.org/pelias/prop-stream)


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
 * [`pelias-model`](https://github.com/pelias/model)    [![Build Status](https://travis-ci.org/pelias/model.svg?branch=master)](https://travis-ci.org/pelias/model)
 * [`pelias-suggester-pipeline`](https://github.com/pelias/suggester-pipeline)    [![Build Status](https://travis-ci.org/pelias/suggester-pipeline.svg?branch=master)](https://travis-ci.org/pelias/suggester-pipeline)
 * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-admin-lookup`](https://github.com/pelias/admin-lookup)    [![Build Status](https://travis-ci.org/pelias/admin-lookup.svg?branch=master)](https://travis-ci.org/pelias/admin-lookup)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`polygon-lookup`](https://github.com/pelias/polygon-lookup)    [![Build Status](https://travis-ci.org/pelias/polygon-lookup.svg?branch=master)](https://travis-ci.org/pelias/polygon-lookup)
   * [`pelias-logger`](https://github.com/pelias/logger)    [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)


<br/>
-----


### [`pelias-openstreetmap`](https://github.com/pelias/openstreetmap)

[![Build Status](https://travis-ci.org/pelias/openstreetmap.svg?branch=master)](https://travis-ci.org/pelias/openstreetmap)

_Pelias openstreetmap utilities_

[![NPM](https://nodei.co/npm/pelias-openstreetmap.png?downloads=true&stars=true)](https://nodei.co/npm/pelias-openstreetmap)

 * [`pbf2json`](https://github.com/pelias/pbf2json)    
 * [`pelias-admin-lookup`](https://github.com/pelias/admin-lookup)    [![Build Status](https://travis-ci.org/pelias/admin-lookup.svg?branch=master)](https://travis-ci.org/pelias/admin-lookup)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`polygon-lookup`](https://github.com/pelias/polygon-lookup)    [![Build Status](https://travis-ci.org/pelias/polygon-lookup.svg?branch=master)](https://travis-ci.org/pelias/polygon-lookup)
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
 * [`pelias-model`](https://github.com/pelias/model)    [![Build Status](https://travis-ci.org/pelias/model.svg?branch=master)](https://travis-ci.org/pelias/model)
 * [`pelias-suggester-pipeline`](https://github.com/pelias/suggester-pipeline)    [![Build Status](https://travis-ci.org/pelias/suggester-pipeline.svg?branch=master)](https://travis-ci.org/pelias/suggester-pipeline)


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


### [`pelias-api`](https://github.com/pelias/api)

[![Build Status](https://travis-ci.org/pelias/api.svg?branch=master)](https://travis-ci.org/pelias/api)

_Pelias API_

 * [`pelias-suggester-pipeline`](https://github.com/pelias/suggester-pipeline)    [![Build Status](https://travis-ci.org/pelias/suggester-pipeline.svg?branch=master)](https://travis-ci.org/pelias/suggester-pipeline)
 * [`pelias-esclient`](https://github.com/pelias/esclient)    [![Build Status](https://travis-ci.org/pelias/esclient.svg?branch=master)](https://travis-ci.org/pelias/esclient)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)


<br/>
-----


### [`fences`](https://github.com/pelias/fences-cli)

[![Build Status](https://travis-ci.org/pelias/fences-cli.svg?branch=master)](https://travis-ci.org/pelias/fences-cli)

_Builds administrative boundary datasets_

[![NPM](https://nodei.co/npm/fences.png?downloads=true&stars=true)](https://nodei.co/npm/fences)

 * [`fences-builder`](https://github.com/pelias/fences-builder)    [![Build Status](https://travis-ci.org/pelias/fences-builder.svg?branch=master)](https://travis-ci.org/pelias/fences-builder)
 * [`fences-slicer`](https://github.com/pelias/fences-slicer)    [![Build Status](https://travis-ci.org/pelias/fences-slicer.svg?branch=master)](https://travis-ci.org/pelias/fences-slicer)


<br/>
-----


### [`pelias-webview`](https://github.com/pelias/dash)



_Pelias web view_

 * [`pelias-esclient`](https://github.com/pelias/esclient)    [![Build Status](https://travis-ci.org/pelias/esclient.svg?branch=master)](https://travis-ci.org/pelias/esclient)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)


<br/>
-----


### [`pelias-quattroshapes`](https://github.com/pelias/deprecated-quattroshapes)



_Pelias quattroshapes utilities_

 * [`pelias-esclient`](https://github.com/pelias/esclient)    [![Build Status](https://travis-ci.org/pelias/esclient.svg?branch=master)](https://travis-ci.org/pelias/esclient)
   * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)


<br/>
-----


### [`pelias-acceptance-tests`](https://github.com/pelias/acceptance-tests)



_Acceptance tests for Pelias Geocoder API_

 * [`pelias-config`](https://github.com/pelias/config)    [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
   * [`mergeable`](https://github.com/pelias/mergeable)    [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)


<br/>
-----


### [`pbf-parser-comparison`](https://github.com/pelias/pbf-parser-comparison)



_no description_

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


### [`pelias-regression-tests`](https://github.com/pelias/regression-tests)

[![Build Status](https://travis-ci.org/pelias/regression-tests.svg?branch=master)](https://travis-ci.org/pelias/regression-tests)

_Pelias regression-tests suite_

no dependencies

<br/>
-----


### [`mapzen-search-team-ownership`](https://github.com/pelias/ownership)



_manage npm owner status in bulk_

[![NPM](https://nodei.co/npm/mapzen-search-team-ownership.png?downloads=true&stars=true)](https://nodei.co/npm/mapzen-search-team-ownership)

no dependencies

<br/>
-----


