require 'spec_helper'

describe Pelias::Suggestion do

  describe :rebuild_suggestions_for_admin0 do

    context 'with a basic admin0' do

      let(:data) { { name: 'name' } }
      let(:suggestion) { Pelias::Suggestion.rebuild_suggestions_for_admin0(Hashie::Mash.new(data)) }

      it 'should use the name as the output' do
        suggestion[:output].should == data[:name]
      end

      it 'should use the name as an input' do
        suggestion[:weight].should == 1
      end

    end

  end

  describe :rebuild_suggestions_for_admin1 do

    context 'with a basic admin1' do

      let(:name) { 'hello' }
      let(:data) { { name: name } }
      let(:suggestion) { Pelias::Suggestion.rebuild_suggestions_for_admin1(Hashie::Mash.new(data)) }

      it 'should use the name as the output' do
        suggestion[:output].should == name
      end

      it 'should use the name as an input' do
        suggestion[:weight].should == 1
      end

    end

  end

  describe :rebuild_suggestions_for_admin2 do

    let(:suggestion) { Pelias::Suggestion.rebuild_suggestions_for_admin2(Hashie::Mash.new(data)) }

    context 'with a zero population' do

      let(:data) { { name: 'name', population: 0 } }

      it 'should have a weight = 1' do
        suggestion[:weight].should == 1
      end

    end

    context 'with a basic admin2' do

      let(:data) { { name: 'name', population: 100_000_000, admin1_name: 'new york', admin1_abbr: 'ny' } }

      it 'should use the name as the output with preference to admin1_abbr' do
        suggestion[:output].should == 'name, ny'
      end

      it 'should use the name as an input' do
        suggestion[:weight].should == 1_000
      end

    end

  end

  describe :rebuild_suggestions_for_local_admin do

    let(:suggestion) { Pelias::Suggestion.rebuild_suggestions_for_local_admin(Hashie::Mash.new(data)) }

    context 'with a basic local_admin' do

      let(:data) { { name: 'name', admin1_abbr: 'a1', admin1_name: 'admin1', locality_name: 'locality', admin2_name: 'admin2', population: 100_000 } }

      it 'should construct a friendly output' do
        suggestion[:output].should == 'name, a1'
      end

      it 'should have a weight based on population' do
        suggestion[:weight].should == 13
      end

    end

  end

end
