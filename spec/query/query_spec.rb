require 'spec_helper'
require 'query/query'
require 'context'
require 'header/secure_header'
require 'auth/master_token'
require 'query/query_request'

describe Azure::DocumentDB::Query do
  let(:uri) { :full_uri_of_resource_typ }
  let(:resource_type) { Azure::DocumentDB::ResourceType.DOCUMENT } # Resource type the query will be ran against
  let(:parent_resource_id) { "parent resource id for example the database '_rid' if you are going to query a collection" }
  let(:full_header) { :header }
  let(:query_request) { gimme(Azure::DocumentDB::QueryRequest) }
  let(:rest_client) { gimme }
  let(:context) { gimme(Azure::DocumentDB::Context) }
  let(:master_token) { gimme(Azure::DocumentDB::MasterToken) }
  let(:secure_header) { gimme(Azure::DocumentDB::SecureHeader) }
  let(:cq_header) { gimme(Azure::DocumentDB::CustomQueryHeader) }
  let(:response) { gimme }
  let(:response_header) { { :stuff => "normal returned header stuff" } }
  let(:response_body) { { "some_stuff" => "in json format" } }
  let(:query_body) { { :query => "query", :parameters => "params" } }
  let(:transformed_result) { { :header => response_header, :body => response_body } }

  let(:query) { Azure::DocumentDB::Query.new context, rest_client, resource_type, parent_resource_id, uri }

  before(:each) {
    give(context).master_token { master_token }
    give(query_request).header(secure_header, parent_resource_id) { full_header }
    give(query_request).body { query_body }
    give(query_request).custom_query_header { cq_header }
    give(Azure::DocumentDB::SecureHeader).new(master_token, resource_type) { secure_header }
    give(rest_client).post(uri, query_body.to_json, full_header) { response }
    give(response).headers { response_header }
    give(response).body { response_body.to_json }
  }

  it "will return results of the query" do
    expect(query.execute query_request).to eq transformed_result
  end

  context "when a continuation_token is returned" do
    let(:transformed_result) { { :header => response_header, :body => response_body, :next_request=> query_request } }
    let(:continuation_token) { :token }
    let(:response_header) { { :x_ms_continuation => :continuation_token } }

    it "adds the updated query request to the response for reuse" do
      expect(query.execute query_request).to eq transformed_result
    end

    it "sets the continuation token on the query_request" do
      query.execute query_request
      verify(cq_header).continuation_token :continuation_token
    end
  end
end
