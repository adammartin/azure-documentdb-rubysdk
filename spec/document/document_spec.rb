require 'spec_helper'
require 'context'
require 'document/document'
require 'header/secure_header'
require 'auth/master_token'
require 'auth/resource_token'

describe Azure::DocumentDB::Document do
  let(:url) { 'our_url' }
  let(:resource_type) { Azure::DocumentDB::ResourceType.DOCUMENT }
  let(:database_id) { 'dbs_rid' }
  let(:collection_rid) { 'coll_rid' }
  let(:document_rid) { 'doc_rid' }
  let(:document_list_rid) { 'doc_list_rid' }
  let(:collection_resource) { "dbs/#{database_id}/colls/#{collection_rid}" }
  let(:documents_url) { "#{url}/#{collection_resource}/#{resource_type}" }
  let(:document_url) { "#{documents_url}/#{document_rid}" }
  let(:rest_client) { gimme }
  let(:context) { gimme(Azure::DocumentDB::Context) }
  let(:master_token) { gimme(Azure::DocumentDB::MasterToken) }
  let(:secure_header) { gimme(Azure::DocumentDB::SecureHeader) }
  let(:query) { gimme(Azure::DocumentDB::Query) }
  let(:create_header_base) { { 'secure_create' => 'header_example' }.clone }
  let(:document_id) { 'sample_name_identifier' }
  let(:raw_document) { { 'key' => 'value' } }
  let(:raw_new_document) { { 'key' => 'new_value' } }
  let(:raw_document_json) { raw_document.to_json }
  let(:raw_new_document_json) { raw_new_document.to_json }
  let(:document_body) { { 'id' => document_id }.merge raw_document }
  let(:document_new_body) { document_body.merge raw_new_document }
  let(:document_server_body) { { '_rid' => document_rid }.merge document_body }
  let(:document_new_server_body) { document_server_body.merge document_new_body }
  let(:document_list) { { '_rid' => document_list_rid, 'Documents' => [document_server_body] } }

  let(:document) { Azure::DocumentDB::Document.new context, rest_client, database_id, collection_rid }

  before(:each) {
    give(context).master_token { master_token }
    give(context).endpoint { url }
    give(Azure::DocumentDB::SecureHeader).new(master_token, resource_type) { secure_header }
    give(Azure::DocumentDB::Query).new(context, rest_client, Azure::DocumentDB::ResourceType.DOCUMENT, collection_rid, documents_url) { query }
  }

  shared_examples 'when supplying an indexing directive' do
    context 'when supplying an indexing directive' do
      let(:create_header_indexing) { 'x-ms-indexing-directive' }
      let(:indexing_directive) { Azure::DocumentDB::Documents::Indexing.INCLUDE }
      let(:index_dir_hash) { { create_header_indexing => indexing_directive } }
      let(:create_header_w_indexing) { create_header_base.merge index_dir_hash }

      before(:each) {
        give(rest_client).post(documents_url, document_body.to_json, create_header_w_indexing) { document_server_body.to_json }
        give(rest_client).put(document_url, document_new_body.to_json, create_header_w_indexing) { document_new_server_body.to_json }
      }

      it 'can create a document for a collection' do
        expect(document.create document_id, raw_document_json, indexing_directive).to eq document_server_body
      end

      it 'can replace a document for a collection' do
        expect(document.replace document_rid, document_id, raw_new_document_json, indexing_directive).to eq document_new_server_body
      end
    end
  end

  shared_examples 'when not supplying an indexing directive' do
    context 'when not supplying an indexing directive' do
      before(:each) {
        give(rest_client).post(documents_url, document_body.to_json, create_header_base) { document_server_body.to_json }
        give(rest_client).put(document_url, document_new_body.to_json, create_header_base) { document_new_server_body.to_json }
      }

      it 'can create a document for a collection' do
        expect(document.create document_id, raw_document_json).to eq document_server_body
      end

      it 'can replace a document for a collection' do
        expect(document.replace document_rid, document_id, raw_new_document_json).to eq document_new_server_body
      end
    end
  end

  shared_examples 'when an Id exists in the document already' do
    context 'when an Id exists in the document already' do
      let(:raw_document) { { 'key' => 'value', 'id' => document_id } }

      include_examples 'when not supplying an indexing directive'
      include_examples 'when supplying an indexing directive'

      context 'and the id in the document does not match the supplied id,' do
        let(:raw_document) { { 'key' => 'value', 'id' => 'Id from some other context' } }

        it 'throws an IdExistsError' do
          expect { document.create document_id, raw_document_json }.to raise_error Azure::DocumentDB::Documents::IdExistsError
        end
      end
    end
  end

  shared_examples 'basic list and get functionality' do
    it 'can list the existing documents' do
      expect(document.list).to eq document_list
    end

    it 'can get a document' do
      expect(document.get document_rid).to eq document_server_body
    end
  end

  it 'can create a query' do
    expect(document.query).to eq query
  end

  context 'When using a master token,' do
    let(:list_header) { 'list_header' }
    let(:get_header) { 'get_header' }
    let(:delete_header) { 'delete_header' }

    before(:each) {
      give(secure_header).header('post', collection_rid) { create_header_base }
      give(secure_header).header('put', document_rid) { create_header_base }
      give(secure_header).header('get', collection_rid) { list_header }
      give(secure_header).header('get', document_rid) { get_header }
      give(secure_header).header('delete', document_rid) { delete_header }
      give(rest_client).get(documents_url, list_header) { document_list.to_json }
      give(rest_client).get(document_url, get_header) { document_server_body.to_json }
    }

    include_examples 'when not supplying an indexing directive'
    include_examples 'when supplying an indexing directive'
    include_examples 'when an Id exists in the document already'
    include_examples 'basic list and get functionality'

    it 'can delete an existing document' do
      document.delete document_rid
      verify(rest_client).delete(document_url, delete_header)
    end
  end

  context 'When using a resource token,' do
    let(:resource_token) { gimme(Azure::DocumentDB::ResourceToken) }
    let(:resource_header) { 'resource_header' }
    let(:document) { Azure::DocumentDB::Document.new context, rest_client, database_id, collection_rid, resource_token }

    before(:each) {
      give(resource_token).encode_header { create_header_base }
      give(rest_client).get(documents_url, create_header_base) { document_list.to_json }
      give(rest_client).get(document_url, create_header_base) { document_server_body.to_json }
    }

    include_examples 'when not supplying an indexing directive'
    include_examples 'when supplying an indexing directive'
    include_examples 'when an Id exists in the document already'
    include_examples 'basic list and get functionality'

    it 'can delete an existing document' do
      document.delete document_rid
      verify(rest_client).delete(document_url, create_header_base)
    end

    it 'can give the uri of the document resource' do
      expect(document.uri).to eq documents_url
    end
  end
end
