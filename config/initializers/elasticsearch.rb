require 'yaml'
require 'elasticsearch'

# elasticsearch configuration
es_config = YAML::load(File.open('config/elasticsearch.yml'))
transport = Elasticsearch::Transport::Transport::HTTP::Faraday.new(hosts: es_config['hosts']) do |c|
  c.options.timeout = es_config['timeout'] || 5
  c.options.open_timeout = es_config['open_timeout'] || 2
end

# put together an elasticsearch client
Pelias::INDEX = es_config['index']
Pelias::ES_CLIENT = Elasticsearch::Client.new(
  transport: transport,
  reload_on_failure: true,
  randomize_hosts: true
)
