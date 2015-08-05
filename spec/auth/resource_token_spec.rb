require 'spec_helper'
require 'auth/resource_token'

describe Azure::DocumentDB::ResourceToken do
  let(:raw_token) { "raw token" }
  let(:encoded_token) { "raw%20token" }
  let(:permission_record) { { "id" => "unimportant", "permissionMode" => "ALL", "resource" => "dbs_resource", "_rid" => "dbs_rid", "_token"=>raw_token } }
  let(:resource_token) { Azure::DocumentDB::ResourceToken.new permission_record }

  it "generates the encoded string" do
    expect(resource_token.encode).to eq encoded_token
  end
end
