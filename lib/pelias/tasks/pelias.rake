require 'pelias'

namespace :pelias do

  desc "setup index & mappings"
  task :setup do
    schema_file = File.read('config/pelias_schema.json')
    schema_json = JSON.parse(schema_file)
    Pelias::ES_CLIENT.indices.create(index: Pelias::INDEX, body: schema_json)
  end

end
