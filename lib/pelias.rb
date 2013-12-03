require "debugger"
require "elasticsearch"
require "geokit"
require "rgeo-geojson"
require "rgeo-shapefile"
require "pg"
require "rspec"
require "zip"
require "sidekiq"
require "sinatra"

require 'pelias/server/server'

module Pelias

  autoload :VERSION, 'pelias/version'

  autoload :Address, 'pelias/address'
  autoload :Base, 'pelias/base'
  autoload :Geoname, 'pelias/geoname'
  autoload :LocalAdmin, 'pelias/local_admin'
  autoload :Locality, 'pelias/locality'
  autoload :Neighborhood, 'pelias/neighborhood'
  autoload :Street, 'pelias/street'

  autoload :Osm, 'pelias/osm'
  autoload :Search, 'pelias/search'

  ES_TIMEOUT = 600

  env = ENV['RACK_ENV'] || 'development'

  es_config = YAML::load(File.open('config/elasticsearch.yml'))[env]
  configuration = lambda do |faraday|
    faraday.adapter Faraday.default_adapter
    #faraday.response :logger
    faraday.options[:timeout] = ES_TIMEOUT
  end
  transport = Elasticsearch::Transport::Transport::HTTP::Faraday.new(
    hosts: es_config['hosts'],
    &configuration
  )
  ES_CLIENT = Elasticsearch::Client.new(transport: transport)

  pg_config = YAML::load(File.open('config/postgres.yml'))[env]
  PG_CLIENT = PG.connect(pg_config)

  def self.root
    File.expand_path '../..', __FILE__
  end

end
