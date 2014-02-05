require 'spec_helper'

describe Pelias::Locality do

  it 'should return name alone if no admin1' do
    Pelias::Locality.new(name: 'something').suggest_output.should == 'something'
  end

  it 'should return name along with abbr if name and code' do
    Pelias::Locality.new({
      name: 'something',
      admin1_code: 'NY',
      admin1_name: 'New York',
      country_code: 'US'
    }).suggest_output.should == 'something, NY'
  end

  it 'should return name along with name if name no abbr' do
    Pelias::Locality.new({
      name: 'something',
      admin1_name: 'New York'
    }).suggest_output.should == 'something, New York'
  end

end
