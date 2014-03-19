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

  end



end
