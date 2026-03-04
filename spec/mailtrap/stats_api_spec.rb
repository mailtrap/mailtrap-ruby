# frozen_string_literal: true

RSpec.describe Mailtrap::StatsAPI, :vcr do
  subject(:stats_api) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }

  let(:start_date) { '2026-01-01' }
  let(:end_date) { '2026-01-31' }

  describe '#get' do
    subject(:stats) { stats_api.get(start_date: start_date, end_date: end_date) }

    it 'returns aggregated sending stats' do
      expect(stats).to be_a(Mailtrap::SendingStats)

      expect(stats).to match_struct(
        delivery_count: 150, delivery_rate: 0.95,
        bounce_count: 8, bounce_rate: 0.05,
        open_count: 120, open_rate: 0.8,
        click_count: 60, click_rate: 0.5,
        spam_count: 2, spam_rate: 0.013
      )
    end

    context 'when api key is incorrect' do
      let(:client) { Mailtrap::Client.new(api_key: 'incorrect-api-key') }

      it 'raises authorization error' do
        expect { stats }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::AuthorizationError)
          expect(error.message).to include('Incorrect API token')
          expect(error.messages.any? { |msg| msg.include?('Incorrect API token') }).to be true
        end
      end
    end
  end

  describe '#by_domains' do
    subject(:stats) { stats_api.by_domains(start_date: start_date, end_date: end_date) }

    it 'returns stats grouped by domains' do
      expect(stats.size).to eq(2)
      expect(stats.first).to match_struct(
        name: :sending_domain_id,
        value: 1,
        stats: match_struct(
          delivery_count: 100, delivery_rate: 0.96,
          bounce_count: 4, bounce_rate: 0.04,
          open_count: 80, open_rate: 0.8,
          click_count: 40, click_rate: 0.5,
          spam_count: 1, spam_rate: 0.01
        )
      )
      expect(stats.last).to match_struct(
        name: :sending_domain_id,
        value: 2,
        stats: match_struct(
          delivery_count: 50, delivery_rate: 0.93,
          bounce_count: 4, bounce_rate: 0.07,
          open_count: 40, open_rate: 0.8,
          click_count: 20, click_rate: 0.5,
          spam_count: 1, spam_rate: 0.02
        )
      )
    end
  end

  describe '#by_categories' do
    subject(:stats) { stats_api.by_categories(start_date: start_date, end_date: end_date) }

    it 'returns stats grouped by categories' do
      expect(stats.size).to eq(2)

      expect(stats.first).to match_struct(
        name: :category,
        value: 'Transactional',
        stats: match_struct(
          delivery_count: 100, delivery_rate: 0.97,
          bounce_count: 3, bounce_rate: 0.03,
          open_count: 85, open_rate: 0.85,
          click_count: 45, click_rate: 0.53,
          spam_count: 0, spam_rate: 0.0
        )
      )
      expect(stats.last).to match_struct(
        name: :category,
        value: 'Marketing',
        stats: match_struct(
          delivery_count: 50, delivery_rate: 0.91,
          bounce_count: 5, bounce_rate: 0.09,
          open_count: 35, open_rate: 0.7,
          click_count: 15, click_rate: 0.43,
          spam_count: 2, spam_rate: 0.04
        )
      )
    end
  end

  describe '#by_email_service_providers' do
    subject(:stats) { stats_api.by_email_service_providers(start_date: start_date, end_date: end_date) }

    it 'returns stats grouped by email service providers' do
      expect(stats.size).to eq(2)
      expect(stats.first).to match_struct(
        name: :email_service_provider,
        value: 'Gmail',
        stats: match_struct(
          delivery_count: 80, delivery_rate: 0.97,
          bounce_count: 2, bounce_rate: 0.03,
          open_count: 70, open_rate: 0.88,
          click_count: 35, click_rate: 0.5,
          spam_count: 1, spam_rate: 0.013
        )
      )
      expect(stats.last).to match_struct(
        name: :email_service_provider,
        value: 'Yahoo',
        stats: match_struct(
          delivery_count: 70, delivery_rate: 0.93,
          bounce_count: 6, bounce_rate: 0.07,
          open_count: 50, open_rate: 0.71,
          click_count: 25, click_rate: 0.5,
          spam_count: 1, spam_rate: 0.014
        )
      )
    end
  end

  describe '#by_date' do
    subject(:stats) { stats_api.by_date(start_date: start_date, end_date: end_date) }

    it 'returns stats grouped by date' do
      expect(stats.size).to eq(2)
      expect(stats.first).to match_struct(
        name: :date,
        value: '2026-01-01',
        stats: match_struct(
          delivery_count: 5, delivery_rate: 1.0,
          bounce_count: 0, bounce_rate: 0.0,
          open_count: 4, open_rate: 0.8,
          click_count: 2, click_rate: 0.5,
          spam_count: 0, spam_rate: 0.0
        )
      )
      expect(stats.last).to match_struct(
        name: :date,
        value: '2026-01-02',
        stats: match_struct(
          delivery_count: 10, delivery_rate: 0.91,
          bounce_count: 1, bounce_rate: 0.09,
          open_count: 8, open_rate: 0.8,
          click_count: 3, click_rate: 0.38,
          spam_count: 0, spam_rate: 0.0
        )
      )
    end
  end
end
