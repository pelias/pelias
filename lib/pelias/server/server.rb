require 'sinatra'
require 'pelias'

class Server < Sinatra::Base

  get '/search' do
    results = Pelias::Search.search(params[:query], params[:viewbox],
      params[:center])['hits']['hits']
    results = results.map do |result|
      {
        name: result['_source']['name'],
        lat: result['_source']['center_point'][1],
        lon: result['_source']['center_point'][0],
        type: result['_source']['suggest']['payload']['type']
      }
    end
    results.to_json
  end

  get '/suggest' do
    results = Pelias::Search.suggest(params[:query])
    results['suggestions'][0]['options'].to_json
  end

  get '/demo' do
    File.read('lib/pelias/server/map.html')
  end

end
