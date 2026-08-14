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

  describe '#get' do
    subject(:get) { api_tokens_api.get(token_id) }

    let(:token_id) { 2_498_561 }

    it 'maps response data to ApiToken object' do
      expect(get).to be_a(Mailtrap::ApiToken)
      expect(get).to have_attributes(
        id: token_id,
        name: an_instance_of(String),
        token: nil
      )
    end

    context 'when token does not exist' do
      let(:token_id) { -1 }

      it 'raises not found error' do
        expect { get }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#create' do
    subject(:create) { api_tokens_api.create(request) }

    let(:url) { "https://mailtrap.io/api/accounts/#{account_id}/api_tokens" }
    let(:request) do
      {
        name: 'Ruby SDK Test Token',
        resources: [
          { resource_type: 'account', resource_id: account_id, access_level: 100 }
        ]
      }
    end

    it 'maps response data to ApiToken with full token value' do
      expect(create).to be_a(Mailtrap::ApiToken)
      expect(create).to have_attributes(
        id: an_instance_of(Integer),
        name: 'Ruby SDK Test Token',
        token: an_instance_of(String)
      )
      expect(WebMock).to(have_requested(:post, url).with { |req| !req.body.include?('expires_at') })
    end

    context 'when expires_at is given' do
      let(:request) do
        {
          name: 'Ruby SDK Test Token',
          expires_at: '2027-06-01T00:00:00Z',
          resources: [
            { resource_type: 'account', resource_id: account_id, access_level: 100 }
          ]
        }
      end

      it 'serializes expires_at in the request body' do
        expect(create).to have_attributes(
          expires_at: '2027-06-01T00:00:00Z',
          token: an_instance_of(String)
        )
        expect(WebMock).to(have_requested(:post, url)
          .with { |req| req.body.include?('"expires_at":"2027-06-01T00:00:00Z"') })
      end
    end

    context 'when expires_at is nil' do
      let(:request) do
        {
          name: 'Ruby SDK Test Token',
          expires_at: nil,
          resources: [
            { resource_type: 'account', resource_id: account_id, access_level: 100 }
          ]
        }
      end

      it 'serializes expires_at as JSON null' do
        expect(create).to have_attributes(expires_at: nil, token: an_instance_of(String))
        expect(WebMock).to(have_requested(:post, url).with { |req| req.body.include?('"expires_at":null') })
      end
    end

    context 'when expires_at is in the past' do
      let(:request) do
        {
          name: 'Ruby SDK Test Token',
          expires_at: '2020-01-01T00:00:00Z',
          resources: [
            { resource_type: 'account', resource_id: account_id, access_level: 100 }
          ]
        }
      end

      it 'raises a Mailtrap::Error' do
        expect { create }.to raise_error(Mailtrap::Error)
      end
    end

    context 'when invalid options are provided' do
      let(:request) { { unknown_option: true } }

      it 'raises ArgumentError' do
        expect { create }.to raise_error(ArgumentError, /invalid options are given/)
      end
    end

    context 'when name is missing' do
      let(:request) { { resources: [] } }

      it 'raises a Mailtrap::Error' do
        expect { create }.to raise_error(Mailtrap::Error)
      end
    end
  end

  describe '#reset' do
    subject(:reset) { api_tokens_api.reset(token_id) }

    let(:token_id) { 2_498_713 }
    let(:url) { "https://mailtrap.io/api/accounts/#{account_id}/api_tokens/#{token_id}/reset" }

    it 'maps response data to ApiToken with new token value' do
      expect(reset).to be_a(Mailtrap::ApiToken)
      expect(reset).to have_attributes(
        id: an_instance_of(Integer),
        token: an_instance_of(String)
      )
      expect(WebMock).to(have_requested(:post, url).with { |req| req.body.to_s.empty? })
    end

    context 'when expires_at is given' do
      subject(:reset) { api_tokens_api.reset(token_id, expires_at: '2027-06-01T00:00:00Z') }

      it 'serializes expires_at in the request body' do
        expect(reset).to have_attributes(
          expires_at: '2027-06-01T00:00:00Z',
          token: an_instance_of(String)
        )
        expect(WebMock).to have_requested(:post, url).with(body: '{"expires_at":"2027-06-01T00:00:00Z"}')
      end
    end

    context 'when expires_at is nil' do
      subject(:reset) { api_tokens_api.reset(token_id, expires_at: nil) }

      it 'serializes expires_at as JSON null' do
        expect(reset).to have_attributes(expires_at: nil, token: an_instance_of(String))
        expect(WebMock).to have_requested(:post, url).with(body: '{"expires_at":null}')
      end
    end

    context 'when expires_at is in the past' do
      subject(:reset) { api_tokens_api.reset(token_id, expires_at: '2020-01-01T00:00:00Z') }

      it 'raises a Mailtrap::Error' do
        expect { reset }.to raise_error(Mailtrap::Error)
      end
    end

    context 'when invalid options are provided' do
      subject(:reset) { api_tokens_api.reset(token_id, unknown_option: true) }

      it 'raises ArgumentError' do
        expect { reset }.to raise_error(ArgumentError, /invalid options are given/)
      end
    end

    context 'when token does not exist' do
      let(:token_id) { -1 }

      it 'raises not found error' do
        expect { reset }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#delete' do
    subject(:delete) { api_tokens_api.delete(token_id) }

    let(:token_id) { 2_498_713 }

    it 'returns nil on success' do
      expect(delete).to be_nil
    end

    context 'when token does not exist' do
      let(:token_id) { -1 }

      it 'raises not found error' do
        expect { delete }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end
end
