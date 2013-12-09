require 'sinatra'
require 'pelias'

class Server < Sinatra::Base

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
          :'marker-symbol' => i
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
          :'marker-color' => '#369100'
        }
      }
    end
    { type: 'FeatureCollection', features: results }.to_json
  end

  get '/demo' do
    File.read('lib/pelias/server/map.html')
  end

end
