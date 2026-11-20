# frozen_string_literal: true

RSpec.describe Mailtrap::SubscriptionTopicsAPI do
  subject(:subscription_topics_api) { described_class.new(Mailtrap::Client.new(api_key: 'correct-api-key')) }

  let(:base_url) { 'https://mailtrap.io/api/subscription_topics' }
  let(:json_headers) { { 'Content-Type' => 'application/json' } }
  let(:topic_attributes) do
    {
      'id' => 12,
      'name' => 'Product updates',
      'description' => 'News about our product',
      'domain_id' => nil,
      'deleted_at' => nil,
      'created_at' => '2026-11-01T10:00:00Z',
      'updated_at' => '2026-11-02T10:00:00Z'
    }
  end

  describe '#list' do
    let(:pagination) do
      { 'token' => 1, 'prev_token' => nil, 'next_token' => 2, 'first_url' => "#{base_url}?token=1" }
    end

    it 'returns a paginated list of SubscriptionTopic objects' do
      stub = stub_request(:get, base_url)
             .to_return(
               status: 200,
               body: { 'data' => [topic_attributes], 'pagination' => pagination }.to_json,
               headers: json_headers
             )

      response = subscription_topics_api.list
      expect(stub).to have_been_requested
      expect(response).to be_a(Mailtrap::SubscriptionTopicsListResponse)
      expect(response.data).to contain_exactly(
        Mailtrap::SubscriptionTopic.new(topic_attributes.transform_keys(&:to_sym))
      )
      expect(response.pagination).to eq(token: 1, prev_token: nil, next_token: 2, first_url: "#{base_url}?token=1")
    end

    it 'passes pagination params' do
      stub = stub_request(:get, base_url)
             .with(query: { per_page: '10', token: '2' })
             .to_return(
               status: 200,
               body: { 'data' => [topic_attributes.merge('domain_id' => 4321)], 'pagination' => { 'token' => 2 } }
                 .to_json,
               headers: json_headers
             )

      response = subscription_topics_api.list(per_page: 10, token: 2)
      expect(stub).to have_been_requested
      expect(response.data.first).to have_attributes(id: 12, domain_id: 4321)
    end

    it 'raises RejectionError when the account has no subscription topics' do
      stub_request(:get, base_url).to_return(status: 403, body: '')

      expect { subscription_topics_api.list }.to raise_error(Mailtrap::RejectionError, 'forbidden')
    end

    it 'raises error when api key is incorrect' do
      stub_request(:get, base_url)
        .to_return(status: 401, body: { 'error' => 'Incorrect API token' }.to_json, headers: json_headers)

      expect { subscription_topics_api.list }.to raise_error(Mailtrap::AuthorizationError, /Incorrect API token/)
    end
  end

  describe '#get' do
    it 'returns a SubscriptionTopic object' do
      stub_request(:get, "#{base_url}/12")
        .to_return(status: 200, body: { 'data' => topic_attributes }.to_json, headers: json_headers)

      response = subscription_topics_api.get(12)
      expect(response).to be_a(Mailtrap::SubscriptionTopic)
      expect(response).to have_attributes(id: 12, name: 'Product updates', domain_id: nil, deleted_at: nil)
    end

    it 'returns a deleted topic' do
      stub_request(:get, "#{base_url}/12")
        .to_return(
          status: 200,
          body: { 'data' => topic_attributes.merge('deleted_at' => '2026-11-10T10:00:00Z') }.to_json,
          headers: json_headers
        )

      expect(subscription_topics_api.get(12).deleted_at).to eq('2026-11-10T10:00:00Z')
    end

    it 'raises RejectionError when the account has no subscription topics' do
      stub_request(:get, "#{base_url}/12").to_return(status: 403, body: '', headers: json_headers)

      expect { subscription_topics_api.get(12) }.to raise_error(Mailtrap::RejectionError, 'forbidden')
    end

    it 'raises error when the topic does not exist' do
      stub_request(:get, "#{base_url}/999")
        .to_return(status: 404, body: { 'error' => 'Not Found' }.to_json, headers: json_headers)

      expect { subscription_topics_api.get(999) }.to raise_error(Mailtrap::Error, /Not Found/)
    end
  end
end
