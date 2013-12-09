require "debugger"
require "elasticsearch"
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

  # elasticsearch
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

  # postgres
  pg_config = YAML::load(File.open('config/postgres.yml'))[env]
  PG_CLIENT = PG.connect(pg_config)

  # sidekiq
  Encoding.default_external = Encoding::UTF_8
  redis_config = YAML::load(File.open('config/redis.yml'))[env]
  redis_url = "redis://#{redis_config['host']}:#{redis_config['port']}/12"
  redis_namespace = redis_config['namespace']
  Sidekiq.configure_server do |config|
    config.redis = { :url => redis_url, :namespace => redis_namespace }
  end
  Sidekiq.configure_client do |config|
    config.redis = { :url => redis_url, :namespace => redis_namespace }
  end

  def self.root
    File.expand_path '../..', __FILE__
  end

end
