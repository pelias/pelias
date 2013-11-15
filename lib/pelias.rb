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
  autoload :Geoname, 'pelias/geoname'
  autoload :Locality, 'pelias/locality'
  autoload :Neighborhood, 'pelias/neighborhood'
  autoload :Street, 'pelias/street'

  autoload :Osm, 'pelias/osm'
  autoload :Search, 'pelias/search'

  # TODO break out into config
  ES_CLIENT = Elasticsearch::Client.new log: false
  PG_CLIENT = PG.connect dbname: 'osm'

  def self.root
    File.expand_path '../..', __FILE__
  end

end
