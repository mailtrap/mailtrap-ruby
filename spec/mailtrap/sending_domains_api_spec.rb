# frozen_string_literal: true

RSpec.describe Mailtrap::SendingDomainsAPI, :vcr do
  subject(:sending_domains_api) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }

  describe '#list' do
    subject(:list) { sending_domains_api.list }

    it 'maps response data to SendingDomain objects' do
      expect(list).to all(be_a(Mailtrap::SendingDomain))
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

  describe '#get' do
    subject(:get) { sending_domains_api.get(sending_domain_id) }

    let(:sending_domain_id) { 617_882 }

    it 'maps response data to SendingDomain object' do
      expect(get).to be_a(Mailtrap::SendingDomain)
      expect(get).to match_struct(
        id: sending_domain_id,
        domain_name: 'demomailtrap.co',
        dns_verified: true,
        compliance_status: 'demo',
        created_at: nil,
        updated_at: nil
      )
    end

    context 'when inbox does not exist' do
      let(:sending_domain_id) { -1 }

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
    subject(:create) { sending_domains_api.create(**request) }

    let(:request) do
      {
        domain_name: 'mailtrappio.com'
      }
    end

    it 'maps response data to Inbox object' do
      expect(create).to be_a(Mailtrap::SendingDomain)
      expect(create).to match_struct(
        id: 943_758,
        domain_name: 'mailtrappio.com',
        dns_verified: false,
        compliance_status: 'unverified_dns',
        created_at: nil,
        updated_at: nil
      )
    end

    context 'when API returns an error' do
      let(:request) do
        {
          domain_name: '' # Invalid value, but present
        }
      end

      it 'raises a Mailtrap::Error' do
        expect { create }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('client error')
        end
      end
    end
  end

  describe '#send_setup_instructions' do
    subject(:send_setup_instructions) do
      sending_domains_api.send_setup_instructions(sending_domain_id, 'yahor.vaitsiakhouski@railsware.com')
    end

    let(:sending_domain_id) { 943_758 }

    it 'returns nil' do
      expect(send_setup_instructions).to be_nil
    end

    context 'when sending domain does not exist' do
      let(:sending_domain_id) { -1 }

      it 'raises not found error' do
        expect { send_setup_instructions }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#delete' do
    subject(:delete) { sending_domains_api.delete(sending_domain_id) }

    let(:sending_domain_id) { 943_758 }

    it 'returns deleted inbox data' do
      expect(delete).to be_nil
    end

    context 'when inbox does not exist' do
      let(:sending_domain_id) { -1 }

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
