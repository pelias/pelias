require "elasticsearch"
require "json"
require "pg"
require 'debugger'
require 'geokit'
require 'hashie'
require 'rgeo/geo_json'
require 'rgeo/shapefile'

require "pelias/base"
require "pelias/address"
require "pelias/locality"
require "pelias/osm"
require "pelias/search"
require "pelias/server/server"
require "pelias/street"
require "pelias/version"

module Pelias

  def self.root
    File.expand_path '../..', __FILE__
  end

end
