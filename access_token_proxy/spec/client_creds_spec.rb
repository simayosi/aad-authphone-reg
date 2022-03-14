# frozen_string_literal: true

RSpec.shared_context 'client' do
  let(:tenant) { 'tenant.example.com' }
  let(:client_id) { 'client-id' }
  let(:config) { { tenant: tenant, client_id: client_id }.merge(param) }
  let(:client) { ClientCreds.new(**config) }
end

RSpec.shared_context 'client with a secret' do
  include_context 'client'
  let(:secret) { 'client secret' }
  let(:param) { { secret: secret } }
end

RSpec.shared_context 'client with an assertion' do
  include_context 'client'
  let(:assertion) { 'client assertion' }
  let(:param) { { assertion: assertion } }
end

RSpec.describe ClientCreds, '#initialize' do
  shared_examples 'MSIDP::ClientCreds instance' do
    subject { client }
    it { is_expected.to be_instance_of ClientCreds }
  end
  context 'with a client secret' do
    include_context 'client with a secret'
    include_examples 'MSIDP::ClientCreds instance'
  end
  context 'with a client assertion' do
    include_context 'client with an assertion'
    include_examples 'MSIDP::ClientCreds instance'
  end
  context 'with no alternative key' do
    include_context 'client'
    let(:param) { {} }
    it { expect { client }.to raise_error(ArgumentError) }
  end
  context 'without mandatory keys' do
    include_context 'client'
    let(:config) { {} }
    it { expect { client }.to raise_error(ArgumentError) }
  end
end

RSpec.shared_context 'token method double' do
  let(:access_token) { 'TOKEN_STRING' }
  let(:expire) { Time.at(1234) + 3599 }
  let(:scope) { 'https://example.com/scope' }
  let(:token) { MSIDP::AccessToken.new(access_token, expire, scope) }
  before do
    allow(client).to receive(:token).and_return(token)
  end
end

RSpec.shared_examples 'accessing the token endpoint' do
  let(:uri) { client.token_uri(tenant) }
  let(:expected_params) do
    param.transform_keys { |k| "client_#{k}".intern }.merge(
      { client_id: client_id, scope: scope }
    )
  end
  subject { client.get_token(scope) }
  it {
    expect(client).to receive(:token)
      .with(uri, hash_including(expected_params))
    is_expected.to have_attributes(
      value: access_token, scope: scope, expire: expire, type: 'Bearer'
    )
  }
end

RSpec.describe ClientCreds, '#get_token' do
  include_context 'token method double'
  context 'to an instance with a client secret' do
    include_context 'client with a secret'
    include_examples 'accessing the token endpoint'
  end
  context 'to an instance with a client assertion' do
    include_context 'client with an assertion'
    include_examples 'accessing the token endpoint'
  end
end
