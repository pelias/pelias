require 'spec_helper'

describe Pelias::QuattroIndexer do

  describe :parent_types_for do

    let(:parents) { Pelias::QuattroIndexer.parent_types_for(type) }

    context 'with the first item in the list' do

      let(:type) { Pelias::QuattroIndexer::SHAPE_ORDER[0] }

      it 'should return an empty array' do
        parents.should == []
      end

    end

    context 'with the last item in the list' do

      let(:type) { Pelias::QuattroIndexer::SHAPE_ORDER[-1] }

      it 'should return all things above that item' do
        parents.should == Pelias::QuattroIndexer::SHAPE_ORDER[0...-1]
      end

    end

  end

end
