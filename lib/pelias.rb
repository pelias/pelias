require 'sidekiq/failures'
require 'yajl'
require 'yajl/json_gem'

$LOAD_PATH << File.dirname(__FILE__)

module Pelias

  autoload :VERSION, 'pelias/version'

  autoload :LocationSet, 'pelias/location_set'
  autoload :LocationIndexer, 'pelias/location_indexer'
  autoload :Search, 'pelias/search'
  autoload :Server, 'pelias/server/server'
  autoload :Suggestion, 'pelias/suggestion'

  autoload :Poi, 'pelias/poi'

  # Load configurations
  Dir.glob('config/initializers/**/*.rb').each { |f| load(f) }

  # Use YAJL
  MultiJson.use :yajl

end
