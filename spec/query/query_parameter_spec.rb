require 'spec_helper'
require 'query/query_param'

describe Azure::DocumentDB::QueryParameter do
  let(:name1) { 'name_of_first_param' }
  let(:name2) { 'name_of_second_param' }
  let(:value1) { 'value_of_first_param' }
  let(:value2) { 'value_of_second_param' }
  let(:qparam) { Azure::DocumentDB::QueryParameter.new }

  it 'returns an empty array when it has no params' do
    expect(qparam.params).to eq []
  end

  it 'returns an array with a single param when it has been added' do
    qparam.add name1, value1
    expect(qparam.params).to eq [{ :name => name1, :value => value1 }]
  end

  it 'returns an array with multiple params when they have been added' do
    qparam.add name1, value1
    qparam.add name2, value2
    expected = [{ :name => name1, :value => value1 }, { :name => name2, :value => value2 }]
    expect(qparam.params).to eq expected
  end
end
