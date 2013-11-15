require 'pelias'

namespace :pelias do

  desc "setup index & mappings"
  task :setup do
    schema_file = File.read('schemas/pelias.json')
    schema_json = JSON.parse(schema_file)
    Pelias::ES_CLIENT.indices.create(index: 'pelias', body: schema_json)
  end

end
