require 'yaml'
require 'elasticsearch'

# elasticsearch configuration
es_config = YAML::load(File.open('config/elasticsearch.yml'))

# put together an elasticsearch client
Pelias::INDEX = es_config['index']
Pelias::ES_CLIENT = Elasticsearch::Client.new(
  reload_on_failure: true,
  randomize_hosts: true,
  transport_options: {
    request: {
      open_timeout: es_config['open_timeout'] || 2,
      timeout: es_config['timeout'] || 5
    }
  }
)
