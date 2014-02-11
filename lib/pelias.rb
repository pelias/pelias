require 'rgeo-geojson'
require 'rgeo-shapefile'
require 'yajl'

require 'pelias/server/server'

module Pelias

  autoload :VERSION, 'pelias/version'

  autoload :Address, 'pelias/address'
  autoload :Admin2, 'pelias/admin2'
  autoload :Base, 'pelias/base'
  autoload :Geoname, 'pelias/geoname'
  autoload :LocalAdmin, 'pelias/local_admin'
  autoload :Locality, 'pelias/locality'
  autoload :Neighborhood, 'pelias/neighborhood'
  autoload :Poi, 'pelias/poi'
  autoload :Street, 'pelias/street'

  autoload :Location, 'pelias/location'
  autoload :Search, 'pelias/search'

  def self.env
    ENV['RAILS_ENV'] || 'development'
  end

  # Load configurations
  Dir.glob('config/initializers/**/*.rb').each { |f| load(f) }

end
