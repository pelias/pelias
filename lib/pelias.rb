require 'sidekiq/failures'
require 'yajl'
require 'yajl/json_gem'

$LOAD_PATH << File.dirname(__FILE__)

module Pelias

  autoload :VERSION, 'pelias/version'

  autoload :LocationSet, 'pelias/location_set'
  autoload :Search, 'pelias/search'
  autoload :Server, 'pelias/server/server'
  autoload :Suggestion, 'pelias/suggestion'

  autoload :GeonameIndexer, 'pelias/geoname_indexer'
  autoload :QuattroIndexer, 'pelias/quattro_indexer'
  autoload :LocationIndexer, 'pelias/location_indexer'

  # Load configurations
  Dir.glob('config/initializers/**/*.rb').each { |f| load(f) }

  # Use YAJL
  MultiJson.use :yajl

end
