require 'spec_helper'

describe Pelias::Street do

  let(:name) { 'a' }
  let(:local_admin_name) { }
  let(:locality_name) { }
  let(:neighborhood_name) { }

  let(:street) {
    Pelias::Street.new({
      name: name,
      local_admin_name: local_admin_name,
      locality_name: locality_name,
      neighborhood_name: neighborhood_name
    })
  }

  context 'with local admin name' do

    let(:local_admin_name) { 'b' }

    it 'should have proper suggest input' do
      street.suggest_input.should == ['a b']
    end

    it 'should have proper output' do
      street.suggest_output.should == 'a, b'
    end

  end

  context 'with locality name and neighborhood name' do

    let(:locality_name) { 'c' }
    let(:neighborhood_name) { 'd' }

    it 'should have proper suggest input' do
      street.suggest_input.should == ['a c', 'a d']
    end

    it 'should have proper output' do
      street.suggest_output.should == 'a, c'
    end

  end

end
