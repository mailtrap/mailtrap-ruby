# frozen_string_literal: true

RSpec.describe Mailtrap::EmailCampaignsAPI, :vcr do
  subject(:email_campaigns_api) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }
  let(:mailsend_domain_id) { 617_882 }

  describe '#list' do
    subject(:list) { email_campaigns_api.list }

    it 'maps response data to a paginated list of EmailCampaign objects' do
      expect(list).to be_a(Mailtrap::EmailCampaignsListResponse)
      expect(list.data).to all(be_a(Mailtrap::EmailCampaign))
      expect(list.pagination).to be_a(Hash)
    end

    context 'when filtering by name and page size' do
      subject(:list) { email_campaigns_api.list(per_page: 10, name: 'Spring') }

      it 'maps response data to a paginated list of EmailCampaign objects' do
        expect(list).to be_a(Mailtrap::EmailCampaignsListResponse)
        expect(list.data).to all(be_a(Mailtrap::EmailCampaign))
      end
    end

    context 'when api key is incorrect' do
      let(:client) { Mailtrap::Client.new(api_key: 'incorrect-api-key') }

      it 'raises authorization error' do
        expect { list }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::AuthorizationError)
          expect(error.message).to include('Incorrect API token')
        end
      end
    end
  end

  describe '#get' do
    subject(:get) { email_campaigns_api.get(email_campaign_id) }

    let(:email_campaign_id) { 4567 }

    it 'maps response data to an EmailCampaign object' do
      expect(get).to be_a(Mailtrap::EmailCampaign)
      expect(get).to have_attributes(
        id: email_campaign_id,
        name: 'Spring Sale',
        current_state: 'draft'
      )
    end

    context 'when the campaign does not exist' do
      let(:email_campaign_id) { -1 }

      it 'raises not found error' do
        expect { get }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
        end
      end
    end
  end

  describe '#create' do
    subject(:create) { email_campaigns_api.create(**request) }

    let(:request) do
      {
        name: 'Spring Sale',
        mailsend_domain_id:,
        from_display_name: 'Acme Marketing',
        from_local_part: 'news',
        reply_to: {
          display_name: 'Acme Support',
          local_part: 'support',
          domain: 'acme.com'
        },
        template_attributes: { subject: 'Spring is here — 30% off' }
      }
    end

    it 'maps response data to an EmailCampaign object' do
      expect(create).to be_a(Mailtrap::EmailCampaign)
      expect(create).to have_attributes(
        name: 'Spring Sale',
        current_state: 'draft'
      )
    end

    context 'when invalid options are provided' do
      let(:request) { { name: 'Spring Sale', unknown_option: true } }

      it 'raises ArgumentError' do
        expect { create }.to raise_error(ArgumentError, /invalid options are given/)
      end
    end

    context 'when the API returns a validation error' do
      let(:request) { { name: 'Spring Sale', mailsend_domain_id: -1 } }

      it 'raises a Mailtrap::Error' do
        expect { create }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
        end
      end
    end
  end

  describe '#update' do
    subject(:update) { email_campaigns_api.update(email_campaign_id, **request) }

    let(:email_campaign_id) { 4567 }
    let(:request) do
      {
        name: 'Spring Sale (updated)',
        delivery_mode: 'scheduled',
        scheduled_for: '2026-06-01T09:00:00.000Z',
        delivery_options: { emails_per_hour: 1000 },
        template_attributes: { id: 789, subject: 'New subject' }
      }
    end

    it 'maps response data to an EmailCampaign object' do
      expect(update).to be_a(Mailtrap::EmailCampaign)
      expect(update).to have_attributes(
        id: email_campaign_id,
        name: 'Spring Sale (updated)'
      )
    end

    context 'when invalid options are provided' do
      let(:request) { { unknown_option: true } }

      it 'raises ArgumentError' do
        expect { update }.to raise_error(ArgumentError, /invalid options are given/)
      end
    end

    context 'when the campaign does not exist' do
      let(:email_campaign_id) { -1 }
      let(:request) { { name: 'Spring Sale (updated)' } }

      it 'raises not found error' do
        expect { update }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
        end
      end
    end
  end

  describe '#delete' do
    subject(:delete) { email_campaigns_api.delete(email_campaign_id) }

    let(:email_campaign_id) { 4567 }

    it 'returns the deleted EmailCampaign object' do
      expect(delete).to be_a(Mailtrap::EmailCampaign)
      expect(delete).to have_attributes(id: email_campaign_id)
    end

    context 'when the campaign does not exist' do
      let(:email_campaign_id) { -1 }

      it 'raises not found error' do
        expect { delete }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
        end
      end
    end
  end

  describe '#stats' do
    subject(:stats) { email_campaigns_api.stats(email_campaign_id) }

    let(:email_campaign_id) { 4567 }

    it 'maps response data to an EmailCampaignStats object' do
      expect(stats).to be_a(Mailtrap::EmailCampaignStats)
      expect(stats).to have_attributes(
        delivery_count: be_a(Integer),
        delivery_rate: be_a(Numeric)
      )
    end

    context 'when the campaign does not exist' do
      let(:email_campaign_id) { -1 }

      it 'raises not found error' do
        expect { stats }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
        end
      end
    end
  end
end
