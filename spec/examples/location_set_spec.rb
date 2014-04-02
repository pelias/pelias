require 'spec_helper'

describe Pelias::LocationSet do

  let(:set) { Pelias::LocationSet.new }

  context 'when using append_records with nil id' do

    before do
      set.append_records 'something', nil
    end

    it 'should have no records' do
      set.records.should be_empty
    end

  end

  context 'with records pre-filled via append_records' do

    let(:location_type) { 'admin0' }

    before do
      expected_data = { index: Pelias::INDEX, type: Pelias::LocationSet::TYPE, body: { query: { term: { 'something' => '1' } } } }
      fake_return = { 'hits' => { 'hits' => [ { '_source' => { 'name' => 'helloworld', 'location_type' => location_type } } ] } }
      Pelias::ES_CLIENT.should_receive(:search).with(expected_data).and_return(fake_return)
    end

    before do
      set.append_records 'something', '1'
    end

    it 'should have a single record' do
      set.records.count.should == 1
    end

    context 'when closing records for an existing type' do

      before do
        set.close_records_for location_type
      end

      it 'should have 1 record' do
        set.records.count.should == 1
      end

    end

    context 'when closing records for a non-existing type' do

      before do
        set.close_records_for (location_type + 'other')
      end

      it 'should have 2 records' do
        set.records.count.should == 2
      end

    end

  end

  context 'with no records pre-filled' do

    it 'should have no records' do
      set.records.should be_empty
    end

    context 'when closing a type which is not present' do

      before do
        set.close_records_for 'admin0'
      end

      it 'should add a new record of that type' do
        set.records.map { |r| r['location_type'] }.should == ['admin0']
      end

    end

  end

end
