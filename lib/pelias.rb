require 'rgeo-geojson'
require 'yajl'
require 'sidekiq/failures'
require 'pelias/server/server'

module Pelias

  autoload :VERSION, 'pelias/version'

  autoload :LocationSet, 'pelias/location_set'
  autoload :Search, 'pelias/search'

  autoload :Address, 'pelias/address'
  autoload :Base, 'pelias/base'
  autoload :Poi, 'pelias/poi'
  autoload :Street, 'pelias/street'

  # Load configurations
  Dir.glob('config/initializers/**/*.rb').each { |f| load(f) }

end
