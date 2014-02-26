require 'yaml'
require 'elasticsearch'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

# elasticsearch configuration
es_config = YAML::load(File.open('config/elasticsearch.yml'))

# put together an elasticsearch client
Pelias::INDEX = es_config['index']

class Faraday::SSLOptions
  def [](key)
    super unless key == :client_cert_passwd
  end
end

transport = Elasticsearch::Transport::Transport::HTTP::Faraday.new(hosts: es_config['hosts']) do |c|
  c.options.timeout = es_config['timeout'] || 5
  c.options.open_timeout = es_config['open_timeout'] || 2
  c.adapter :typhoeus
end

Pelias::ES_CLIENT = Elasticsearch::Client.new(
  reload_on_failure: true,
  randomize_hosts: true,
  transport: transport
)
