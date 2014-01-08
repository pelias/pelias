require 'sinatra'
require 'pelias'

class Server < Sinatra::Base

  set :show_exceptions, false

  get '/search' do
    size = params[:size] || 10
    results = Pelias::Search.search(params[:query], params[:viewbox],
      params[:center], size)
    i = 0
    results = results['hits']['hits'].map do |result|
      i += 1
      {
        type: 'Feature',
        geometry: result['_source']['center_shape'],
        properties: {
          title: result['_source']['name'],
          description: result['_source']['suggest']['payload']['type'],
          :'marker-color' => '#369100',
          :'marker-symbol' => i,
          country_code: result['_source']['country_code'],
          country_name: result['_source']['country_name'],
          admin1_abbr: result['_source']['admin1_code'],
          admin1_name: result['_source']['admin1_name'],
          admin2_name: result['_source']['admin2_name'],
          locality_name: result['_source']['locality_name'],
          local_admin_name: result['_source']['local_admin_name']
        }
      }
    end
    { type: 'FeatureCollection', features: results }.to_json
  end

  get '/suggest' do
    size = params[:size] || 20
    results = Pelias::Search.suggest(params[:query], size)
    results = results['suggestions'][0]['options'].map do |result|
      {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [result['payload']['lon'], result['payload']['lat']]
        },
        properties: {
          title: result['text'],
          description: result['payload']['type'],
          :'marker-color' => '#369100',
          country_code: result['payload']['country_code'],
          country_name: result['payload']['country_name'],
          admin1_abbr: result['payload']['admin1_abbr'],
          admin1_name: result['payload']['admin1_name'],
          admin2_name: result['payload']['admin2_name'],
          locality_name: result['payload']['locality_name'],
          local_admin_name: result['payload']['local_admin_name']
        }
      }
    end
    { type: 'FeatureCollection', features: results }.to_json
  end

  get '/reverse' do
    results = Pelias::Search.reverse_geocode(params[:lng], params[:lat])
    results.to_json
  end

  get '/demo' do
    File.read('lib/pelias/server/map.html')
  end

  # override the default 'Sinatra
  #   doesn't know this ditty' error page
  #
  error Sinatra::NotFound do
    content_type 'text/plain'
    [404, 'Not Found']
  end

end
