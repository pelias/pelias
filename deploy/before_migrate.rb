Chef::Log.info("Running deploy/before_migrate.rb...")

node[:mapzen_pelias][:custom_cfgs].each do |cfg|
  Chef::Log.info("Symlinking #{release_path}/config/#{cfg} to /etc/mapzen_pelias/#{cfg}")
  link "#{release_path}/config/#{cfg}" do
    to "/etc/mapzen_pelias/#{cfg}"
  end
end

