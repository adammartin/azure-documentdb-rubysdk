require_relative '../context'
require_relative '../query/query'
require_relative '../header/secure_header'
require_relative '../auth/master_token'
require_relative '../auth/resource_token'

module Azure
  module DocumentDB
    module Documents
      # rubocop:disable Style/VariableName, Lint/UselessAccessModifier
      class Indexing
        class << self
          attr_reader :INCLUDE, :EXCLUDE
        end

        private

        @INCLUDE = 'Include'.freeze
        @EXCLUDE = 'Exclude'.freeze
      end

      class IdExistsError < ArgumentError; end
    end
    # rubocop:enable Style/VariableName, Lint/UselessAccessModifier

    class Document
      def initialize context, rest_client, database_id, collection_id, resource_token = nil
        self.context = context
        self.rest_client = rest_client
        self.resource_type = Azure::DocumentDB::ResourceType.DOCUMENT
        self.secure_header = Azure::DocumentDB::SecureHeader.new context.master_token, resource_type
        self.database_id = database_id
        self.collection_id = collection_id
        self.resource_token = resource_token
      end

      def create document_id, document, indexing_directive = nil
        body = document_body document_id, document
        header = indexing_header 'post', collection_id, indexing_directive
        JSON.parse(rest_client.post url, body.to_json, header)
      end

      def replace document_rid, document_id, document, indexing_directive = nil
        url = url document_rid
        body = document_body document_id, document
        header = indexing_header 'put', document_rid, indexing_directive
        JSON.parse(rest_client.put url, body.to_json, header)
      end

      def list
        header = header 'get', collection_id
        JSON.parse(rest_client.get url, header)
      end

      def get document_rid
        url = url document_rid
        header = header 'get', document_rid
        JSON.parse(rest_client.get url, header)
      end

      def delete document_rid
        url = url document_rid
        header = header 'delete', document_rid
        rest_client.delete url, header
      end

      def query
        Azure::DocumentDB::Query.new context, rest_client, resource_type, collection_id, url
      end

      def uri
        url
      end

      private

      attr_accessor :context, :rest_client, :resource_type, :secure_header, :database_id, :collection_id, :resource_token

      def url resource_id = nil
        target = '/' + resource_id if resource_id
        "#{context.endpoint}/dbs/#{database_id}/colls/#{collection_id}/#{resource_type}#{target}"
      end

      def header verb, resource_id
        return secure_header.header verb, resource_id unless resource_token
        resource_token.encode_header
      end

      def indexing_directive_hash indexing_directive
        { 'x-ms-indexing-directive' => indexing_directive }
      end

      def id_mismatch document_id, document
        parsed = JSON.parse document
        fail Documents::IdExistsError.new if parsed['id'] && parsed['id'] != document_id
        false
      end

      def document_body document_id, document
        { 'id' => document_id }.merge JSON.parse(document) unless id_mismatch(document_id, document)
      end

      def indexing_header verb, id, indexing_directive
        header = header verb, id
        header.merge! indexing_directive_hash(indexing_directive) if indexing_directive
        header
      end
    end
  end
end
