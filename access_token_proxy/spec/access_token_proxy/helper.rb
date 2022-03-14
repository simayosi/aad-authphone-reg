# frozen_string_literal: true

RSpec.shared_context 'token' do
  let(:value) { 'token' }
  let(:scope) { 'https://example.com/.default' }
  let(:expire) { Time.now + 10 }
  let(:token) { MSIDP::AccessToken.new(value, expire, scope) }
  let(:attributes) { { value: value, scope: scope, expire: expire } }
end

RSpec.shared_context 'client_creds' do
  include_context 'token'
  let(:client_creds) { instance_double(ClientCreds, get_token: token) }
  before do
    allow(ClientCreds).to receive(:new).and_return(client_creds)
  end
end

RSpec.shared_examples 'returning a token twice' do
  subject { -> { AccessTokenProxy.token(scope) } }
  it {
    expect(subject.call).to have_attributes(attributes)
    expect(subject.call).to have_attributes(attributes)
  }
end
