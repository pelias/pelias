require 'pelias'

namespace :pelias do

  desc "setup index & mappings"
  task :setup do
    schema_file = File.read('lib/pelias/config/pelias_schema.json')
    schema_json = JSON.parse(schema_file)
    Pelias::ES_CLIENT.indices.create(index: 'pelias_new', body: schema_json)
  end

end
