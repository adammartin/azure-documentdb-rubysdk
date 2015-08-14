require 'spec_helper'
require 'query/query'
require 'context'
require 'header/secure_header'
require 'header/custom_query_header'
require 'auth/master_token'
require 'query/query_param'

describe Azure::DocumentDB::Query do
  let(:uri) { "full uri of the resource type" }
  let(:resource_type) { Azure::DocumentDB::ResourceType.DOCUMENT } # Resource type the query will be ran against
  let(:parent_resource_id) { "parent resource id for example the database '_rid' if you are going to query a collection" }
  let(:query) { "select * from resource" }
  let(:raw_secure_header) { "secure_header" }
  let(:full_header) { "full_header" }
  let(:params) { "parameters" }
  let(:query_params) { gimme(Azure::DocumentDB::QueryParameter) }
  let(:custom_query_header) { gimme(Azure::DocumentDB::CustomQueryHeader) }
  let(:rest_client) { gimme }
  let(:context) { gimme(Azure::DocumentDB::Context) }
  let(:master_token) { gimme(Azure::DocumentDB::MasterToken) }
  let(:secure_header) { gimme(Azure::DocumentDB::SecureHeader) }
  let(:response) { gimme }
  let(:response_header) { "header" }
  let(:response_body) { { "some_stuff" => "in json format" } }
  let(:transformed_result) { { :header => response_header, :body => response_body } }
  let(:query_body) { { :query => query, :parameters => params } }

  let(:db_query) { Azure::DocumentDB::Query.new context, rest_client, resource_type, parent_resource_id, uri }

  before(:each) {
    give(context).master_token { master_token }
    give(custom_query_header).header(raw_secure_header) { full_header }
    give(Azure::DocumentDB::SecureHeader).new(master_token, resource_type) { secure_header }
    give(query_params).params { params }
    give(secure_header).header("post", parent_resource_id) { raw_secure_header }
    give(rest_client).post(uri, query_body.to_json, full_header) { response }
    give(response).headers { response_header }
    give(response).body { response_body.to_json }
  }

  it "will return results of the query" do
    expect(db_query.execute query, custom_query_header, query_params).to eq transformed_result
  end
end
