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
        id: 617_882,
        domain_name: 'demomailtrap.co',
        demo: true,
        compliance_status: 'demo',
        dns_verified: true,
        dns_verified_at: '2025-05-21T14:04:52.363Z',
        dns_records:
          [
            { key: 'verification', domain: 'demo.demomailtrap.co', type: 'CNAME', value: 'smtp.mailtrap.live',
              status: 'pass', name: 'demo' },
            { key: 'dkim1', domain: 'rwmt1._domainkey.demomailtrap.co', type: 'CNAME',
              value: 'rwmt1.dkim.smtp.mailtrap.live', status: 'pass', name: 'rwmt1._domainkey' },
            { key: 'dkim2', domain: 'rwmt2._domainkey.demomailtrap.co', type: 'CNAME',
              value: 'rwmt2.dkim.smtp.mailtrap.live', status: 'pass', name: 'rwmt2._domainkey' },
            { key: 'dmarc', name: '_dmarc' },
            { key: 'link_verification', domain: 'mt-link.demomailtrap.co', type: 'CNAME', value: 't.mailtrap.live',
              status: 'pass', name: 'mt-link' }
          ],
        open_tracking_enabled: true,
        click_tracking_enabled: false,
        auto_unsubscribe_link_enabled: false,
        custom_domain_tracking_enabled: false,
        health_alerts_enabled: true,
        critical_alerts_enabled: true,
        alert_recipient_email: nil,
        permissions: { can_read: true, can_update: true, can_destroy: true },
        created_at: nil,
        updated_at: nil
      )
    end

    context 'when sending domain does not exist' do
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

    it 'maps response data to sending domain object' do
      expect(create).to be_a(Mailtrap::SendingDomain)

      expect(create).to match_struct(
        id: 943_758,
        domain_name: 'mailtrappio.com',
        demo: false,
        compliance_status: 'unverified_dns',
        dns_verified: false,
        dns_verified_at: '',
        dns_records:
          [
            { key: 'verification', domain: 'mt07.mailtrappio.com', type: 'CNAME', value: 'smtp.mailtrap.live',
              status: 'missing', name: 'mt07' },
            { key: 'dkim1', domain: 'rwmt1._domainkey.mailtrappio.com', type: 'CNAME',
              value: 'rwmt1.dkim.smtp.mailtrap.live', status: 'missing', name: 'rwmt1._domainkey' },
            { key: 'dkim2', domain: 'rwmt2._domainkey.mailtrappio.com', type: 'CNAME',
              value: 'rwmt2.dkim.smtp.mailtrap.live', status: 'missing', name: 'rwmt2._domainkey' },
            { key: 'dmarc', name: '_dmarc' },
            { key: 'link_verification', domain: 'mt-link.mailtrappio.com', type: 'CNAME', value: 't.mailtrap.live',
              status: 'missing', name: 'mt-link' }
          ],
        open_tracking_enabled: true,
        click_tracking_enabled: false,
        auto_unsubscribe_link_enabled: false,
        custom_domain_tracking_enabled: false,
        health_alerts_enabled: true,
        critical_alerts_enabled: true,
        alert_recipient_email: nil,
        permissions: { can_read: true, can_update: true, can_destroy: true },
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
      sending_domains_api.send_setup_instructions(sending_domain_id, email: 'example@railsware.com')
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

    it 'returns deleted sending domain data' do
      expect(delete).to be_nil
    end

    context 'when sending domain does not exist' do
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
