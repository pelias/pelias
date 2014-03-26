require 'yaml'
require 'sidekiq'

# Load configuration
redis_config = YAML.load_file('config/redis.yml')
configuration = {
  url: "redis://#{redis_config['host']}:#{redis_config['port']}/#{redis_config['database']}",
  namespace: redis_config['namespace']
}

Pelias::REDIS = Redis.new configuration
