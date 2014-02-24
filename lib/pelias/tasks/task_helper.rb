require 'bundler/setup'
require 'pelias'
require 'ruby-progressbar'
require 'rgeo-geojson'

# Hide the sidekiq log
Sidekiq::Logging.logger = nil

# Set up a temp path for downloaded files
TEMP_PATH = '/tmp/mapzen'
