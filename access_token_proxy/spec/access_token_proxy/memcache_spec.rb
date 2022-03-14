# frozen_string_literal: true

require 'access_token_proxy/memcache'
require_relative 'helper'

RSpec.shared_context 'Memcache' do
  include_context 'client_creds'
  before do
    AccessTokenProxy.config = {}
    AccessTokenProxy.use nil
  end
end

RSpec.describe AccessTokenProxy::Memcache, '#token' do
  include_context 'Memcache'
  subject { AccessTokenProxy.token(scope) }
  context 'in case of a cached valid token' do
    include_examples 'returning a token twice'
    before { expect(client_creds).to receive(:get_token).once }
  end
  context 'in case of a cached expired token' do
    let(:expire) { Time.now - 1 }
    include_examples 'returning a token twice'
    before { expect(client_creds).to receive(:get_token).twice }
  end
end
