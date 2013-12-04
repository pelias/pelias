require './lib/pelias'
run Server

require 'sidekiq'
Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

redis_config = YAML::load(File.open('config/redis.yml'))[env]
Sidekiq.configure_client do |config|
  config.redis = {
    :url => "redis://#{redis_config['host']}:#{redis_config['port']}/12",
    :namespace => redis_config['namespace']
  }
end

require 'sidekiq/web'
run Rack::URLMap.new('/' => Server, '/sidekiq' => Sidekiq::Web)
