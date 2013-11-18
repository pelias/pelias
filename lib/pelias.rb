require "elasticsearch"
require "json"
require "pg"
require 'debugger'
require 'geokit'
require 'rgeo/geo_json'
require 'rgeo/shapefile'

require 'pelias/server/server'

module Pelias

  autoload :VERSION, 'pelias/version'

  autoload :Address, 'pelias/address'
  autoload :Base, 'pelias/base'
  autoload :Gazette, 'pelias/gazette'
  autoload :Geoname, 'pelias/geoname'
  autoload :LocalAdmin, 'pelias/local_admin'
  autoload :Locality, 'pelias/locality'
  autoload :Neighborhood, 'pelias/neighborhood'
  autoload :Street, 'pelias/street'

  autoload :Osm, 'pelias/osm'
  autoload :Search, 'pelias/search'

  es_config = YAML::load(File.open('config/elasticsearch.yml'))[RACK_ENV]
  ES_CLIENT = Elasticsearch::Client.new(
    host: es_config['host'],
    log: es_config['log']
  )
  pg_config = YAML::load(File.open('config/postgres.yml'))[RACK_ENV]
  PG_CLIENT = PG.connect(pg_config)

  def self.root
    File.expand_path '../..', __FILE__
  end

end
