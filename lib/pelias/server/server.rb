require 'sinatra'
require 'pelias'

class Server < Sinatra::Base

  get '/search' do
    size = params[:size] || 10
    results = Pelias::Search.search(params[:query], params[:viewbox],
      params[:center], size)
    results = results['hits']['hits'].map do |result|
      {
        type: 'Feature',
        geometry: result['_source']['center_shape'],
        properties: {
          name: result['_source']['name'],
          type: result['_source']['suggest']['payload']['type']
        }
      }
    end
    { type: 'FeatureCollection', features: results }.to_json
  end

  get '/suggest' do
    size = params[:size] || 20
    results = Pelias::Search.suggest(params[:query], size)
    results['suggestions'][0]['options'].to_json
  end

  get '/demo' do
    File.read('lib/pelias/server/map.html')
  end

end
