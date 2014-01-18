require 'sinatra'
require 'pelias'

class Server < Sinatra::Base

  set :show_exceptions, false

  get '/search' do
    response['Access-Control-Allow-Origin'] = '*'
    size = params[:size] || 10
    results = Pelias::Search.search(params[:query], params[:viewbox], params[:center], size)
    results = results['hits']['hits'].map do |result|
      {
        type: 'Feature',
        geometry: result['_source']['center_shape'],
        properties: {
          name: result['_source']['name'],
          type: result['_source']['suggest']['payload']['type'],
          country_code: result['_source']['country_code'],
          country_name: result['_source']['country_name'],
          admin1_abbr: result['_source']['admin1_code'],
          admin1_name: result['_source']['admin1_name'],
          admin2_name: result['_source']['admin2_name'],
          locality_name: result['_source']['locality_name'],
          local_admin_name: result['_source']['local_admin_name'],
          neighborhood_name: result['_source']['neighborhood_name']
        }
      }
    end
    { type: 'FeatureCollection', features: results }.to_json
  end

  get '/suggest' do
    response['Access-Control-Allow-Origin'] = '*'
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
          name: result['text'],
          type: result['payload']['type'],
          country_code: result['payload']['country_code'],
          country_name: result['payload']['country_name'],
          admin1_abbr: result['payload']['admin1_abbr'],
          admin1_name: result['payload']['admin1_name'],
          admin2_name: result['payload']['admin2_name'],
          locality_name: result['payload']['locality_name'],
          local_admin_name: result['payload']['local_admin_name'],
          neighborhood_name: result['payload']['neighborhood_name']
        }
      }
    end
    { type: 'FeatureCollection', features: results }.to_json
  end

  get '/reverse' do
    response['Access-Control-Allow-Origin'] = '*'
    results = Pelias::Search.reverse_geocode(params[:lng], params[:lat])
    results.to_json
  end

  get '/closest' do
    response['Access-Control-Allow-Origin'] = '*'
    results = Pelias::Search.closest(params[:lng], params[:lat], params[:type])
    results.to_json
  end

  # override the default 'Sinatra
  #   doesn't know this ditty' error page
  #
  error Sinatra::NotFound do
    content_type 'text/plain'
    [404, 'Not Found']
  end

end
