require 'yaml'
require 'sequel'

# Load configuration
pg_config = YAML::load(File.open('config/postgres.yml'))
pg_config.symbolize_keys!
pg_config[:database] ||= pg_config[:dbname] # legacy setting

# And connect
Pelias::PG_CONFIG = pg_config
Pelias::DB = Sequel.postgres(pg_config)
