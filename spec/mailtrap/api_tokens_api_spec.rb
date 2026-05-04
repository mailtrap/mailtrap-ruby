# frozen_string_literal: true

RSpec.describe Mailtrap::ApiTokensAPI, :vcr do
  subject(:api_tokens_api) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }

  describe '#list' do
    subject(:list) { api_tokens_api.list }

    it 'maps response data to ApiToken objects' do
      expect(list).to all(be_a(Mailtrap::ApiToken))
      expect(list.first).to have_attributes(
        id: an_instance_of(Integer),
        name: an_instance_of(String),
        token: nil
      )
    end
  end
end
