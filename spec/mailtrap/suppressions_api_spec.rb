# frozen_string_literal: true

RSpec.describe Mailtrap::SuppressionsAPI, :vcr do
  subject(:suppressions) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }
  let(:domain_id) { 12_345 }
  let(:suppression_id) { 'fef0c580-1086-4ede-9fea-b8f5e256ba89' }

  describe '#list' do
    subject(:list) { suppressions.list }

    it 'maps response data to Suppression objects' do
      expect(list).to all(be_a(Mailtrap::Suppression))
      expect(list.first).to have_attributes(
        id: be_a(String),
        type: be_a(String),
        created_at: be_a(String),
        email: be_a(String),
        sending_stream: be_a(String),
        domain_name: be_a(String)
      )
    end

    context 'with email filter' do
      subject(:list) { suppressions.list(email: 'recipient@example.com') }

      it 'returns the matching suppressions' do
        expect(list).to all(be_a(Mailtrap::Suppression))
      end
    end

    context 'when api key is incorrect' do
      let(:client) { Mailtrap::Client.new(api_key: 'incorrect-api-key') }

      it 'raises authorization error' do
        expect { list }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::AuthorizationError)
          expect(error.message).to include('Incorrect API token')
          expect(error.messages.any? { |msg| msg.include?('Incorrect API token') }).to be true
        end
      end
    end
  end

  describe '#create' do
    subject(:create) { suppressions.create(request) }

    let(:request) do
      {
        email: 'recipient.new@example.com',
        domain_id:,
        sending_stream: 'transactional'
      }
    end

    it 'maps response data to Suppression object' do
      expect(create).to be_a(Mailtrap::Suppression)
      expect(create).to have_attributes(
        id: be_a(String),
        email: be_a(String),
        sending_stream: 'transactional',
        type: be_a(String)
      )
    end

    context 'with an explicit type' do
      let(:request) do
        {
          email: 'recipient.unsubscribed@example.com',
          domain_id:,
          sending_stream: 'transactional',
          type: 'unsubscription'
        }
      end

      it 'returns the suppression with that type' do
        expect(create.type).to eq('unsubscription')
      end
    end

    context 'when invalid options are provided' do
      let(:request) { super().merge(unknown_option: true) }

      it 'raises ArgumentError' do
        expect { create }.to raise_error(ArgumentError, /invalid options are given/)
      end
    end

    context 'when email is invalid' do
      let(:request) { super().merge(email: 'not-an-email') }

      it 'raises a Mailtrap::Error' do
        expect { create }.to raise_error(Mailtrap::Error)
      end
    end
  end

  describe '#delete' do
    subject(:delete) { suppressions.delete(suppression_id) }

    it 'returns the deleted suppression' do
      expect(delete).to be_a(Mailtrap::Suppression)
      expect(delete).to have_attributes(
        id: be_a(String),
        email: be_a(String)
      )
    end

    context 'when suppression does not exist' do
      let(:suppression_id) { 'missing' }

      it 'raises a Mailtrap::Error' do
        expect { delete }.to raise_error(Mailtrap::Error)
      end
    end
  end
end
