require 'yaml'
require 'ostruct'

configuration = YAML.load_file('config/pelias.yml')
Pelias::CONFIG = OpenStruct.new configuration
