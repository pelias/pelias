require_relative 'lib/pelias'

# Mount the root app
map '/' do
  run Pelias::Server
end

# Conditionally mount sidekiq workers interface
if Pelias::CONFIG.mount_sidekiq
  map '/workers' do
    require 'sidekiq/web'
    require 'sidekiq/failures'
    run Sidekiq::Web
  end
end
