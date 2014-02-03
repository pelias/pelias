require 'spec_helper'
require 'rack/test'

describe 'Pelias Demo Calls' do

  include Rack::Test::Methods

  def app
    Pelias::Server
  end


  describe 'reverse geocode' do

    let(:json) { JSON.parse(last_response.body) }

    it 'reverse geocodes' do
      get '/reverse', lat: 40.730352, lng: -73.986391
      last_response.should be_ok
      json['level'].should == 'address'
      json['locality_name'].should == 'New York City'
      json['name'].should be_present
    end

  end

  describe 'search' do

    let(:first_json) { JSON.parse(last_response.body)['features'].first }

    it 'searches' do
      get '/search', query: 'madison square park'
      last_response.should be_ok
      first_json['properties']['name'].should == 'Madison Square Park'
    end

    it 'searches within a box' do
      get '/search', query: 'madison square park', viewbox:'-73.97476673126219,40.75546586313989,-73.99085998535155,40.74408691819078'
      last_response.should be_ok
      first_json['properties']['name'].should_not == 'Madison Square Park'
    end

    it 'searches within a box sorting from center' do
      get '/search', query: 'madison square park', viewbox:'-73.97476673126219,40.75546586313989,-73.99085998535155,40.74408691819078'
      last_response.should be_ok
      first_json['properties']['name'].should_not == 'Madison Square Park'
    end

  end

end
