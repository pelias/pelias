require './lib/pelias'
run Server

require 'sidekiq'
Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

require 'sidekiq/web'
run Rack::URLMap.new('/' => Sinatra::Application, '/sidekiq' => Sidekiq::Web)
