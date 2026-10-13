# frozen_string_literal: true

RSpec.describe Mailtrap::MarketingStatsAPI do
  subject(:marketing_stats_api) { described_class.new(Mailtrap::Client.new(api_key: 'correct-api-key')) }

  let(:base_url) { 'https://mailtrap.io/api/marketing/stats' }
  let(:stats_attributes) do
    {
      delivery_count: 1200,
      delivery_rate: 0.96,
      bounce_count: 50,
      bounce_rate: 0.04,
      open_count: 600,
      open_rate: 0.5,
      click_count: 240,
      click_rate: 0.2,
      spam_count: 3,
      spam_rate: 0.0025,
      unsubscription_count: 12,
      unsubscription_rate: 0.01,
      sent_count: 1250
    }
  end
  let(:success_response) do
    { status: 200, body: { 'data' => stats_attributes }.to_json, headers: { 'Content-Type' => 'application/json' } }
  end

  describe '#get' do
    subject(:stats) { marketing_stats_api.get(start_date: '2026-05-01', end_date: '2026-05-31') }

    it 'returns a MarketingStats object' do
      stub = stub_request(:get, "#{base_url}?start_date=2026-05-01&end_date=2026-05-31")
             .to_return(success_response)

      expect(stats).to be_a(Mailtrap::MarketingStats)
      expect(stats).to match_struct(stats_attributes)
      expect(stub).to have_been_requested
    end

    context 'with optional filters' do
      subject(:stats) do
        marketing_stats_api.get(
          start_date: '2026-05-01',
          end_date: '2026-05-31',
          sending_domain_ids: [3938, 3939],
          sources: ['campaigns'],
          email_service_providers: %w[Google Yahoo]
        )
      end

      it 'sends every filter as an array query parameter' do
        stub = stub_request(
          :get,
          "#{base_url}?start_date=2026-05-01&end_date=2026-05-31" \
          '&sending_domain_ids[]=3938&sending_domain_ids[]=3939&sources[]=campaigns' \
          '&email_service_providers[]=Google&email_service_providers[]=Yahoo'
        ).to_return(success_response)

        expect(stats).to have_attributes(delivery_count: 1200, sent_count: 1250)
        expect(stub).to have_been_requested
      end
    end

    it 'sends DateTime and Time arguments as plain dates' do
      stub = stub_request(:get, "#{base_url}?start_date=2026-05-01&end_date=2026-05-31")
             .to_return(success_response)

      marketing_stats_api.get(start_date: DateTime.new(2026, 5, 1, 13, 45), end_date: Time.new(2026, 5, 31, 23, 59))

      expect(stub).to have_been_requested
    end

    it 'leaves out empty filters' do
      allow(marketing_stats_api.client).to receive(:get).and_return(data: stats_attributes)

      marketing_stats_api.get(start_date: '2026-05-01', end_date: '2026-05-31', sending_domain_ids: [],
                              sources: ['campaigns'])

      expect(marketing_stats_api.client).to have_received(:get).with(
        '/api/marketing/stats',
        { start_date: '2026-05-01', end_date: '2026-05-31', 'sources[]' => ['campaigns'] }
      )
    end

    it 'raises ArgumentError for an invalid date' do
      expect { marketing_stats_api.get(start_date: '2026-05-01', end_date: '2026-13-01') }
        .to raise_error(ArgumentError, /Invalid date: "2026-13-01"/)
    end

    it 'raises error when a filter is rejected' do
      stub_request(:get, "#{base_url}?start_date=2026-05-01&end_date=2026-05-31&sources[]=newsletters")
        .to_return(
          status: 400,
          body: { 'errors' => "Invalid source: 'newsletters'" }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { marketing_stats_api.get(start_date: '2026-05-01', end_date: '2026-05-31', sources: ['newsletters']) }
        .to raise_error(Mailtrap::Error, "Invalid source: 'newsletters'")
    end

    it 'raises authorization error when the API key is incorrect' do
      stub_request(:get, "#{base_url}?start_date=2026-05-01&end_date=2026-05-31")
        .to_return(
          status: 401,
          body: { 'error' => 'Incorrect API token' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { stats }.to raise_error(Mailtrap::AuthorizationError, 'Incorrect API token')
    end
  end

  describe 'vcr#get', :vcr do
    subject(:stats) do
      described_class.new(client).get(start_date: '2026-09-01', end_date: '2026-09-30', sources: ['campaigns'])
    end

    let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }

    it 'maps response data to a MarketingStats object' do
      expect(stats).to be_a(Mailtrap::MarketingStats)
      expect(stats).to have_attributes(
        delivery_count: be_a(Integer),
        delivery_rate: be_a(Numeric),
        open_count: be_a(Integer),
        open_rate: be_a(Numeric),
        sent_count: be_a(Integer)
      )
    end
  end
end
