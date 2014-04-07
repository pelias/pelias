require 'pelias'

namespace :index do

  desc 'setup index & mappings'
  task :create do
    schema_file = File.read('config/pelias_schema.json').gsub('%DIRPATH%', File.expand_path('.'))
    schema_json = JSON.parse(schema_file)
    Pelias::ES_CLIENT.indices.create(index: Pelias::INDEX, body: schema_json)
  end

  desc 'destroy index'
  task :destroy do
    Pelias::ES_CLIENT.indices.delete(index: Pelias::INDEX)
  end

  desc 'refresh index'
  task :refresh do
    Pelias::ES_CLIENT.indices.refresh(index: Pelias::INDEX)
  end

  desc 'update settings'
  task :update_settings do
    schema_file = File.read('config/pelias_schema.json').gsub('%DIRPATH%', File.expand_path('.'))
    schema_json = JSON.parse(schema_file)['settings']
    Pelias::ES_CLIENT.indices.close(index: Pelias::INDEX)
    Pelias::ES_CLIENT.indices.put_settings(index: Pelias::INDEX, body: schema_json)
    Pelias::ES_CLIENT.indices.open(index: Pelias::INDEX)
  end

  desc 'update mapping'
  task :update_mapping do
    schema_file = File.read('config/pelias_schema.json')
    schema_json = JSON.parse(schema_file)['mappings']
    Pelias::ES_CLIENT.indices.put_mapping(index: Pelias::INDEX, body: schema_json, type: 'location')
  end

end
