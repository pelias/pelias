# Pelias packages
Table of contents:

  [pelias-addresses](#pelias-addresses)
<br/>
  [pelias-openaddresses](#pelias-openaddresses)
<br/>
  [quattroshapes-pipeline](#quattroshapes-pipeline)
<br/>
  [pelias-geonames](#pelias-geonames)
<br/>
  [pelias-openstreetmap](#pelias-openstreetmap)
<br/>
  [pelias-tiger](#pelias-tiger)
<br/>
  [fences](#fences)
<br/>
  [pelias-api](#pelias-api)
<br/>
  [pelias-quattroshapes](#pelias-quattroshapes)
<br/>
  [pelias-webview](#pelias-webview)
<br/>
  [pelias-acceptance-tests](#pelias-acceptance-tests)
<br/>
  [pbf-parser-comparison](#pbf-parser-comparison)
<br/>
  [feedback](#feedback)
<br/>
  [pelias-init](#pelias-init)
<br/>
  [mapzen-search-team-ownership](#mapzen-search-team-ownership)
<br/>
  [pelias-regression-tests](#pelias-regression-tests)
<br/>
--------



### [`pelias-addresses`](https://github.com/pelias/addresses)

[![Build Status](https://travis-ci.org/pelias/addresses.svg?branch=master)](https://travis-ci.org/pelias/addresses)

_Mapzen addresses pipeline for generating a high-quality dump of global addresses._

[![NPM](https://nodei.co/npm/pelias-addresses.png?downloads=true&stars=true)](https://nodei.co/npm/pelias-addresses)

 * [`line-interpolate-points`](https://github.com/pelias/line-interpolate-points)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/line-interpolate-points.svg?branch=master)](https://travis-ci.org/pelias/line-interpolate-points)
 * [`schema-mapper`](https://github.com/pelias/schema-mapper)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/schema-mapper.svg?branch=master)](https://travis-ci.org/pelias/schema-mapper)
 * [`prop-stream`](https://github.com/pelias/prop-stream)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/prop-stream.svg?branch=master)](https://travis-ci.org/pelias/prop-stream)
 * [`pelias-schema`](https://github.com/pelias/schema)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/schema.svg?branch=master)](https://travis-ci.org/pelias/schema)
   * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-suggester-pipeline`](https://github.com/pelias/suggester-pipeline)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/suggester-pipeline.svg?branch=master)](https://travis-ci.org/pelias/suggester-pipeline)
 * [`pelias-dbclient`](https://github.com/pelias/dbclient)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/dbclient.svg?branch=master)](https://travis-ci.org/pelias/dbclient)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-model`](https://github.com/pelias/model)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/model.svg?branch=master)](https://travis-ci.org/pelias/model)


<br/>
-----


### [`pelias-openaddresses`](https://github.com/pelias/openaddresses)

[![Build Status](https://travis-ci.org/pelias/openaddresses.svg?branch=master)](https://travis-ci.org/pelias/openaddresses)

_Pelias import pipeline for OpenAddresses._

[![NPM](https://nodei.co/npm/pelias-openaddresses.png?downloads=true&stars=true)](https://nodei.co/npm/pelias-openaddresses)

 * [`pelias-address-deduplicator`](https://github.com/pelias/address-deduplicator)  [<i>pelias</i>]   
   * [`pelias-logger`](https://github.com/pelias/logger)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-model`](https://github.com/pelias/model)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/model.svg?branch=master)](https://travis-ci.org/pelias/model)
 * [`pelias-dbclient`](https://github.com/pelias/dbclient)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/dbclient.svg?branch=master)](https://travis-ci.org/pelias/dbclient)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-suggester-pipeline`](https://github.com/pelias/suggester-pipeline)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/suggester-pipeline.svg?branch=master)](https://travis-ci.org/pelias/suggester-pipeline)
 * [`pelias-admin-lookup`](https://github.com/pelias/admin-lookup)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/admin-lookup.svg?branch=master)](https://travis-ci.org/pelias/admin-lookup)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`polygon-lookup`](https://github.com/pelias/polygon-lookup)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/polygon-lookup.svg?branch=master)](https://travis-ci.org/pelias/polygon-lookup)
   * [`pelias-logger`](https://github.com/pelias/logger)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-logger`](https://github.com/pelias/logger)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
   * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)


<br/>
-----


### [`quattroshapes-pipeline`](https://github.com/pelias/quattroshapes-pipeline)



_no description_

 * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
   * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-dbclient`](https://github.com/pelias/dbclient)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/dbclient.svg?branch=master)](https://travis-ci.org/pelias/dbclient)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-schema`](https://github.com/pelias/schema)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/schema.svg?branch=master)](https://travis-ci.org/pelias/schema)
   * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-admin-lookup`](https://github.com/pelias/admin-lookup)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/admin-lookup.svg?branch=master)](https://travis-ci.org/pelias/admin-lookup)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`polygon-lookup`](https://github.com/pelias/polygon-lookup)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/polygon-lookup.svg?branch=master)](https://travis-ci.org/pelias/polygon-lookup)
   * [`pelias-logger`](https://github.com/pelias/logger)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-suggester-pipeline`](https://github.com/pelias/suggester-pipeline)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/suggester-pipeline.svg?branch=master)](https://travis-ci.org/pelias/suggester-pipeline)
 * [`prop-stream`](https://github.com/pelias/prop-stream)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/prop-stream.svg?branch=master)](https://travis-ci.org/pelias/prop-stream)


<br/>
-----


### [`pelias-geonames`](https://github.com/pelias/geonames)

[![Build Status](https://travis-ci.org/pelias/geonames.svg?branch=master)](https://travis-ci.org/pelias/geonames)

_Open-source geo-coder & reverse geo-coder_

[![NPM](https://nodei.co/npm/pelias-geonames.png?downloads=true&stars=true)](https://nodei.co/npm/pelias-geonames)

 * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
   * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-dbclient`](https://github.com/pelias/dbclient)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/dbclient.svg?branch=master)](https://travis-ci.org/pelias/dbclient)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-model`](https://github.com/pelias/model)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/model.svg?branch=master)](https://travis-ci.org/pelias/model)
 * [`pelias-suggester-pipeline`](https://github.com/pelias/suggester-pipeline)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/suggester-pipeline.svg?branch=master)](https://travis-ci.org/pelias/suggester-pipeline)
 * [`pelias-logger`](https://github.com/pelias/logger)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-admin-lookup`](https://github.com/pelias/admin-lookup)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/admin-lookup.svg?branch=master)](https://travis-ci.org/pelias/admin-lookup)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`polygon-lookup`](https://github.com/pelias/polygon-lookup)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/polygon-lookup.svg?branch=master)](https://travis-ci.org/pelias/polygon-lookup)
   * [`pelias-logger`](https://github.com/pelias/logger)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)


<br/>
-----


### [`pelias-openstreetmap`](https://github.com/pelias/openstreetmap)

[![Build Status](https://travis-ci.org/pelias/openstreetmap.svg?branch=master)](https://travis-ci.org/pelias/openstreetmap)

_Pelias openstreetmap utilities_

[![NPM](https://nodei.co/npm/pelias-openstreetmap.png?downloads=true&stars=true)](https://nodei.co/npm/pelias-openstreetmap)

 * [`pbf2json`](https://github.com/pelias/pbf2json)  [<i>pelias</i>]   
 * [`pelias-admin-lookup`](https://github.com/pelias/admin-lookup)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/admin-lookup.svg?branch=master)](https://travis-ci.org/pelias/admin-lookup)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`polygon-lookup`](https://github.com/pelias/polygon-lookup)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/polygon-lookup.svg?branch=master)](https://travis-ci.org/pelias/polygon-lookup)
   * [`pelias-logger`](https://github.com/pelias/logger)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
   * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-dbclient`](https://github.com/pelias/dbclient)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/dbclient.svg?branch=master)](https://travis-ci.org/pelias/dbclient)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-model`](https://github.com/pelias/model)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/model.svg?branch=master)](https://travis-ci.org/pelias/model)
 * [`pelias-suggester-pipeline`](https://github.com/pelias/suggester-pipeline)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/suggester-pipeline.svg?branch=master)](https://travis-ci.org/pelias/suggester-pipeline)


<br/>
-----


### [`pelias-tiger`](https://github.com/pelias/tiger)



_A pipeline for importing TIGER data into Pelias._

 * [`pelias-dbclient`](https://github.com/pelias/dbclient)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/dbclient.svg?branch=master)](https://travis-ci.org/pelias/dbclient)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
   * [`pelias-logger`](https://github.com/pelias/logger)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/logger.svg?branch=master)](https://travis-ci.org/pelias/logger)
     * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
       * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)
 * [`pelias-suggester-pipeline`](https://github.com/pelias/suggester-pipeline)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/suggester-pipeline.svg?branch=master)](https://travis-ci.org/pelias/suggester-pipeline)
 * [`line-interpolate-points`](https://github.com/pelias/line-interpolate-points)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/line-interpolate-points.svg?branch=master)](https://travis-ci.org/pelias/line-interpolate-points)
 * [`pelias-model`](https://github.com/pelias/model)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/model.svg?branch=master)](https://travis-ci.org/pelias/model)


<br/>
-----


### [`fences`](https://github.com/pelias/fences-cli)

[![Build Status](https://travis-ci.org/pelias/fences-cli.svg?branch=master)](https://travis-ci.org/pelias/fences-cli)

_Builds administrative boundary datasets_

[![NPM](https://nodei.co/npm/fences.png?downloads=true&stars=true)](https://nodei.co/npm/fences)

 * [`fences-builder`](https://github.com/pelias/fences-builder)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/fences-builder.svg?branch=master)](https://travis-ci.org/pelias/fences-builder)
 * [`fences-slicer`](https://github.com/pelias/fences-slicer)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/fences-slicer.svg?branch=master)](https://travis-ci.org/pelias/fences-slicer)


<br/>
-----


### [`pelias-api`](https://github.com/pelias/api)

[![Build Status](https://travis-ci.org/pelias/api.svg?branch=master)](https://travis-ci.org/pelias/api)

_Pelias API_

 * [`pelias-suggester-pipeline`](https://github.com/pelias/suggester-pipeline)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/suggester-pipeline.svg?branch=master)](https://travis-ci.org/pelias/suggester-pipeline)
 * [`pelias-esclient`](https://github.com/pelias/esclient)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/esclient.svg?branch=master)](https://travis-ci.org/pelias/esclient)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)


<br/>
-----


### [`pelias-quattroshapes`](https://github.com/pelias/quattroshapes)



_Pelias quattroshapes utilities_

 * [`pelias-esclient`](https://github.com/pelias/esclient)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/esclient.svg?branch=master)](https://travis-ci.org/pelias/esclient)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)


<br/>
-----


### [`pelias-webview`](https://github.com/pelias/dash)



_Pelias web view_

 * [`pelias-esclient`](https://github.com/pelias/esclient)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/esclient.svg?branch=master)](https://travis-ci.org/pelias/esclient)
   * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
     * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)


<br/>
-----


### [`pelias-acceptance-tests`](https://github.com/pelias/acceptance-tests)



_Acceptance tests for Pelias Geocoder API_

 * [`pelias-config`](https://github.com/pelias/config)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/config.svg?branch=master)](https://travis-ci.org/pelias/config)
   * [`mergeable`](https://github.com/pelias/mergeable)  [<i>pelias</i>]   [![Build Status](https://travis-ci.org/pelias/mergeable.svg?branch=master)](https://travis-ci.org/pelias/mergeable)


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


