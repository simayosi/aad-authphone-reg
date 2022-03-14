# frozen_string_literal: true

require_relative 'active_record_mock'
require 'access_token_proxy/db_cache'
require_relative 'helper'

RSpec.shared_context 'cached_token double' do
  let(:cached_token) { instance_double(AccessTokenProxy::CachedToken) }
  let(:cache) { cached_token }
  before do
    allow(AccessTokenProxy::CachedToken).to receive(:transaction).and_yield
    allow(AccessTokenProxy::CachedToken)
      .to receive(:lock).and_return(AccessTokenProxy::CachedToken)
    allow(AccessTokenProxy::CachedToken)
      .to receive(:find_by).and_return(cache)
    allow(cached_token).to receive_messages(
      value: value, expire: expire, scope: scope
    )
  end
end

RSpec.shared_context 'DBCache' do
  include_context 'client_creds'
  include_context 'cached_token double'
  before do
    AccessTokenProxy.config = {}
    AccessTokenProxy.use :db_cache
  end
end

RSpec.describe AccessTokenProxy::DBCache, '#token' do
  include_context 'DBCache'
  context 'in case of a cached valid token' do
    include_examples 'returning a token twice'
    before { expect(AccessTokenProxy::CachedToken).to receive(:find_by).once }
    before { expect(cached_token).not_to receive(:update!) }
    before { expect(client_creds).not_to receive(:get_token) }
  end
  context 'in case of a cached expired token' do
    let(:expire) { Time.now - 1 }
    include_examples 'returning a token twice'
    before { expect(client_creds).to receive(:get_token).twice }
    before { expect(cached_token).to receive(:update!).twice }
  end
  context 'in case of no cached token' do
    let(:cache) { nil }
    include_examples 'returning a token twice'
    before { expect(client_creds).to receive(:get_token).once }
    before { expect(AccessTokenProxy::CachedToken).to receive(:create!).once }
  end
end
