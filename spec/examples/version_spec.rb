require 'spec_helper'

describe Pelias::VERSION do

  it 'should have a version' do
    Pelias::VERSION.should_not be_empty
  end

end
