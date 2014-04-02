require 'spec_helper'
require 'rack/test'

describe Pelias::Server do

  include Rack::Test::Methods
  def app; Pelias::Server; end

  describe '/search' do

    context 'with results' do

      before do
        res = { 'hits' => { 'hits' => [ { '_source' => { 'name' => 'nyc' } } ] } }
        Pelias::Search.should_receive(:search).with('hello', nil, nil, 10).and_return(res)
        get '/search?query=hello'
      end

      it 'should receive a 200' do
        last_response.should be_ok
      end

      it 'should receive a collection with one result' do
        JSON.parse(last_response.body)['features'].map { |f| f['properties']['name'] }.should == ['nyc']
      end

    end

    context 'with a size specified' do

      before do
        res = { 'hits' => { 'hits' => [ { '_source' => { 'name' => 'nyc' } } ] } }
        Pelias::Search.should_receive(:search).with('hello', nil, nil, 100).and_return(res)
        get '/search?query=hello&size=100'
      end

      it 'should receive a 200' do
        last_response.should be_ok
      end

    end

    [0, 1000, 'a'].each do |size|
      context "with invalid size == #{size}" do

        before do
          get "/suggest?query=hello&size=#{size}"
        end

        it 'should receive a 200' do
          last_response.should be_bad_request
        end

      end
    end

  end

  describe '/suggest' do

    context 'with results' do

      before do
        res = { 'suggestions' => [ { 'options' => [ { 'payload' => { 'name' => 'nyc' } } ] } ] }
        Pelias::Search.should_receive(:suggest).with('hello', 10).and_return(res)
        get '/suggest?query=hello'
      end

      it 'should receive a 200' do
        last_response.should be_ok
      end

      it 'should receive a collection with one result' do
        JSON.parse(last_response.body)['features'].map { |f| f['properties']['name'] }.should == ['nyc']
      end

    end

    context 'with a size specified' do

      before do
        res = { 'suggestions' => [ { 'options' => [ { 'payload' => { 'name' => 'nyc' } } ] } ] }
        Pelias::Search.should_receive(:suggest).with('hello', 100).and_return(res)
        get '/suggest?query=hello&size=100'
      end

      it 'should receive a 200' do
        last_response.should be_ok
      end

    end

    [0, 1000, 'a'].each do |size|
      context "with invalid size == #{size}" do

        before do
          get "/suggest?query=hello&size=#{size}"
        end

        it 'should receive a 200' do
          last_response.should be_bad_request
        end

      end
    end

  end

  describe '/reverse' do

    context 'with a regular reverse lookup - no size specified' do

      before do
        res = { '_source' => { 'name' => 'nyc' } }
        Pelias::Search.should_receive(:reverse_geocode).with(1, 2).and_return(res)
        get '/reverse?lng=1&lat=2' # as it were
      end

      it 'should get a 200' do
        last_response.should be_ok
      end

      it 'should get the result' do
        JSON.parse(last_response.body)['features'].map { |f| f['properties']['name'] }.should == ['nyc']
      end

    end

  end

  describe '/demo' do

    before do
      get '/demo'
    end

    it 'should be able to render the demo' do
      last_response.should be_ok
    end

  end

  describe 'invalid route' do

    before do
      get '/nothing'
    end

    it 'should get a 404' do
      last_response.should be_not_found
    end

    it 'should get a message' do
      JSON.parse(last_response.body)['message'].should == 'invalid route'
    end

  end

end
