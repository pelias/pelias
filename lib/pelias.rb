require 'yajl'
require 'sidekiq/failures'
require 'pelias/server/server'

module Pelias

  autoload :VERSION, 'pelias/version'

  autoload :LocationSet, 'pelias/location_set'
  autoload :Search, 'pelias/search'

  autoload :Address, 'pelias/address'
  autoload :Poi, 'pelias/poi'

  # Load configurations
  Dir.glob('config/initializers/**/*.rb').each { |f| load(f) }

  # Use YAJL
  MultiJson.use :yajl

end
