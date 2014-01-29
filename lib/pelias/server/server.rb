require 'sinatra'
require 'sinatra/jbuilder'

class Server < Sinatra::Base

  set :show_exceptions, false

  before do
    headers 'Access-Control-Allow-Origin' => '*'
  end

  # Search endpoint
  get '/search' do
    size = params[:size] || 10
    results = Pelias::Search.search(params[:query], params[:viewbox], params[:center], size)
    @hits = results['hits']['hits']
    jbuilder :search
  end

  # Suggest endpoint
  get '/suggest' do
    size = params[:size] || 20
    results = Pelias::Search.suggest(params[:query], size)
    @hits = results['suggestions'][0]['options']
    jbuilder :suggest
  end

  get '/reverse' do
    results = Pelias::Search.reverse_geocode(params[:lng], params[:lat])
    results.to_json
  end

  get '/closest' do
    results = Pelias::Search.closest(params[:lng], params[:lat], params[:type], 1500)
    results = results['hits']['hits'].map do |result|
      {
        type: 'Feature',
        geometry: result['_source']['center_shape'],
        properties: {
          osm_id: result['_id'],
          name: result['_source']['name'],
          street_number: result['_source']['number'],
          street_name: result['_source']['street_name'],
          feature: result['_source']['feature'],
          phone: result['_source']['phone'],
          website: result['_source']['website'],
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

  # override the default "Sinatra doesn't know this ditty" error page
  error Sinatra::NotFound do
    content_type 'text/plain'
    [404, 'Not Found']
  end

end
