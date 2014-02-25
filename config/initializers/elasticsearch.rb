require 'yaml'
require 'elasticsearch'

# elasticsearch configuration
es_config = YAML::load(File.open('config/elasticsearch.yml'))
transport = Elasticsearch::Transport::Transport::HTTP::Faraday.new(hosts: es_config['hosts']) do |faraday|
  faraday.adapter Faraday.default_adapter
  faraday.options[:timeout] = es_config['timeout'] || 1200
end

# put together an elasticsearch client
Pelias::ES_CLIENT = Elasticsearch::Client.new(transport: transport, reload_on_failure: true, retry_on_failure: true, randomize_hosts: true)
Pelias::INDEX = es_config['index']
