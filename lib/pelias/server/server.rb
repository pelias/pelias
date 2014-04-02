require 'sinatra'
require 'sinatra/jbuilder'

module Pelias
  class Server < Sinatra::Base

    set :public_folder, 'lib/pelias/server/static'
    set :show_exceptions, false

    before do
      headers 'Access-Control-Allow-Origin' => '*'
    end

    # Search endpoint
    # query: The query to look up
    # size:  The number of results to return (default 10)
    get '/search' do
      size = params[:size] ? params[:size].to_i : 10
      return render_error(400, 'invalid size') if size <= 0 || size > 100
      results = Pelias::Search.search(params[:query], params[:viewbox], params[:center], size)
      @hits = results['hits'] ? results['hits']['hits'] : []
      jbuilder :search
    end

    # Suggest endpoint
    # query: The query to look up
    # size:  The number of results to return (default 10)
    get '/suggest' do
      size = params[:size] ? params[:size].to_i : 10
      return render_error(400, 'invalid size') if size <= 0 || size > 100
      results = Pelias::Search.suggest(params[:query], size)
      @hits = results['suggestions'] ? results['suggestions'][0]['options'] : []
      jbuilder :search
    end

    # Reverse geocode endpoint
    # lng: the longitude to lookup
    # lat: the latitude to lookup
    get '/reverse' do
      @hits = [Pelias::Search.reverse_geocode(params[:lng].to_f, params[:lat].to_f)].compact
      jbuilder :search
    end

    # Render a demo page to allow search & autocomplete
    get '/demo' do
      erb :demo
    end

    # override the default "Sinatra doesn't know this ditty" error page
    error Sinatra::NotFound do
      render_error 404, 'invalid route'
    end

    # How to respond to a bad request
    def render_error(status, msg)
      content_type :json
      status status
      { message: msg }.to_json
    end

  end
end
