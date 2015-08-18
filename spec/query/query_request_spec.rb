require 'spec_helper'
require 'header/custom_query_header'
require 'header/secure_header'
require 'query/query_param'
require 'query/query_request'

describe Azure::DocumentDB::QueryRequest do
  let(:cq_header) { gimme(Azure::DocumentDB::CustomQueryHeader) }
  let(:params) { gimme(Azure::DocumentDB::QueryParameter) }
  let(:raw_params) { 'params' }
  let(:query_string) { 'select * from root' }
  let(:secure_header) { gimme(Azure::DocumentDB::SecureHeader) }
  let(:raw_secure_header) { 'secure_header' }
  let(:full_header) { 'full_header' }
  let(:parent_resource_id) { 'rid' }
  let(:query_body) { { :query => query_string, :parameters => raw_params } }

  let(:qrequest) { Azure::DocumentDB::QueryRequest.new query_string }

  before(:each) {
    give(Azure::DocumentDB::CustomQueryHeader).new { cq_header }
    give(Azure::DocumentDB::QueryParameter).new { params }
    give(secure_header).header('post', parent_resource_id) { raw_secure_header }
    give(cq_header).header(raw_secure_header) { full_header }
    give(params).params { raw_params }
  }

  it 'can give the query string' do
    expect(qrequest.query_string).to eq query_string
  end

  it "won't allow you to modify the query_string after creation" do
    expect { qrequest.query_string.concat 'blarg' }.to raise_error RuntimeError, "can't modify frozen String"
  end

  it 'will give access to a custom query header' do
    expect(qrequest.custom_query_header).to eq cq_header
  end

  it 'will give access to the query parameters' do
    expect(qrequest.parameters).to eq params
  end

  it 'will build a header for a supplied secure_header and parent_resource_id' do
    expect(qrequest.header secure_header, parent_resource_id).to eq full_header
  end

  it 'will build the raw body of a request' do
    expect(qrequest.body).to eq query_body
  end
end
