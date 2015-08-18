require 'spec_helper'
require 'collection/index_policy'

describe Azure::DocumentDB::IndexPolicy do
  let(:index_path) { gimme(Azure::DocumentDB::IndexPath) }
  let(:path_body) { { 'stuff' => 'results' }.to_json }
  let(:automatic) { true }
  let(:mode) { Azure::DocumentDB::IndexingMode.CONSISTENT }
  let(:include_paths) { [index_path] }
  let(:include_paths_body) { [path_body] }
  let(:exclude_paths) { [] }
  let(:expected_policy_body) { { 'automatic' => automatic, 'indexingMode' => mode, 'IncludePaths' => include_paths_body, 'ExcludePaths' => exclude_paths }.to_json }
  let(:policy) { Azure::DocumentDB::IndexPolicy.new automatic, mode, include_paths, exclude_paths }

  before(:each) {
    give(index_path).body { path_body }
  }

  it 'Will generate the expected json body result' do
    expect(policy.body).to eq expected_policy_body
  end
end
