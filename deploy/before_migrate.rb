Chef::Log.info("Running deploy/before_migrate.rb...")

node[:mapzen_pelias][:custom_cfgs].each do |cfg|
  Chef::Log.info("Symlinking #{release_path}/config/#{cfg} to #{node[:mapzen_pelias][:cfg_dir]}/#{cfg}")
  link "#{release_path}/config/#{cfg}" do
    to "#{node[:mapzen_pelias][:cfg_dir]}/#{cfg}"
  end
end

