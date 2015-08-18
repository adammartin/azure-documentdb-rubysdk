require 'spec_helper'
require 'header/custom_query_header'
require 'query/query_param'
require 'query/query_request'

describe Azure::DocumentDB::QueryRequest do
  let(:cq_header) { gimme(Azure::DocumentDB::CustomQueryHeader) }
  let(:params) { gimme(Azure::DocumentDB::QueryParameter) }
  let(:query_string) { "select * from root" }

  let(:qrequest) { Azure::DocumentDB::QueryRequest.new query_string }

  before(:each) {
    give(Azure::DocumentDB::CustomQueryHeader).new { cq_header }
    give(Azure::DocumentDB::QueryParameter).new { params }
  }

  it "can give the query string" do
    expect(qrequest.query_string).to eq query_string
  end

  it "won't allow you to modify the query_string after creation" do
    expect{qrequest.query_string.concat "blarg"}.to raise_error RuntimeError, "can't modify frozen String"
  end

  it "will give access to a custom query header" do
    expect(qrequest.custom_query_header).to eq cq_header
  end

  it "will give access to the query parameters" do
    expect(qrequest.parameters).to eq params
  end
end
