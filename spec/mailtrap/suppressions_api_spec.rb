# frozen_string_literal: true

RSpec.describe Mailtrap::SuppressionsAPI do
  subject(:suppressions) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }

  let(:base_url) { "https://mailtrap.io/api/accounts/#{account_id}" }

  describe '#list' do
    let(:expected_attributes) do
      {
        'id' => '123e4567-e89b-12d3-a456-426614174000',
        'type' => 'hard bounce',
        'created_at' => '2024-06-01T12:00:00Z',
        'email' => 'user1@example.com',
        'sending_stream' => 'transactional',
        'domain_name' => 'example.com',
        'message_bounce_category' => 'invalid recipient',
        'message_category' => 'transactional',
        'message_client_ip' => '192.0.2.1',
        'message_created_at' => '2024-06-01T11:59:00Z',
        'message_esp_response' => '550 5.1.1 User unknown',
        'message_esp_server_type' => 'smtp',
        'message_outgoing_ip' => '198.51.100.1',
        'message_recipient_mx_name' => 'mx.example.com',
        'message_sender_email' => 'sender@example.com',
        'message_subject' => 'Test subject'
      }
    end
    let(:expected_response) do
      [
        expected_attributes,
        {
          'id' => '456e7890-e89b-12d3-a456-426614174001',
          'type' => 'spam complaint',
          'created_at' => '2024-06-01T13:00:00Z',
          'email' => 'user2@example.com',
          'sending_stream' => 'bulk',
          'domain_name' => 'example.org',
          'message_bounce_category' => nil,
          'message_category' => 'bulk',
          'message_client_ip' => '192.0.2.2',
          'message_created_at' => '2024-06-01T12:59:00Z',
          'message_esp_response' => nil,
          'message_esp_server_type' => nil,
          'message_outgoing_ip' => '198.51.100.2',
          'message_recipient_mx_name' => 'mx.example.org',
          'message_sender_email' => 'sender2@example.com',
          'message_subject' => 'Bulk email subject'
        }
      ]
    end

    it 'returns all suppressions' do
      stub_request(:get, "#{base_url}/suppressions")
        .to_return(
          status: 200,
          body: expected_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = suppressions.list
      expect(response).to all(be_a(Mailtrap::Suppression))
      expect(response.length).to eq(2)
      expect(response.first).to have_attributes(expected_attributes)
    end

    it 'returns suppressions filtered by email' do
      email = 'user1@example.com'
      stub_request(:get, "#{base_url}/suppressions?email=#{email}")
        .to_return(
          status: 200,
          body: [expected_attributes].to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = suppressions.list(email:)
      expect(response).to all(be_a(Mailtrap::Suppression))
      expect(response.length).to eq(1)
      expect(response.first).to have_attributes(expected_attributes)
    end

    it 'raises error when unauthorized' do
      stub_request(:get, "#{base_url}/suppressions")
        .to_return(
          status: 401,
          body: { 'error' => 'Unauthorized' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { suppressions.list }.to raise_error(Mailtrap::AuthorizationError)
    end
  end

  describe '#create' do
    let(:request) { { email: 'user@example.com', domain_id: 12_345, sending_stream: 'transactional' } }
    let(:created_attributes) do
      {
        'id' => '123e4567-e89b-12d3-a456-426614174000',
        'type' => 'manual import',
        'created_at' => '2024-06-01T12:00:00Z',
        'email' => 'user@example.com',
        'sending_stream' => 'transactional',
        'domain_name' => 'example.com'
      }
    end

    it 'sends a flat body and maps the wrapped response' do
      stub_request(:post, "#{base_url}/suppressions")
        .with(body: request.to_json)
        .to_return(
          status: 201,
          body: { 'data' => created_attributes }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      suppression = suppressions.create(request)

      expect(suppression).to be_a(Mailtrap::Suppression)
      expect(suppression).to have_attributes(
        id: '123e4567-e89b-12d3-a456-426614174000',
        email: 'user@example.com',
        sending_stream: 'transactional',
        type: 'manual import'
      )
    end

    it 'sends the optional type when provided' do
      stub_request(:post, "#{base_url}/suppressions")
        .with(body: request.merge(type: 'spam complaint').to_json)
        .to_return(
          status: 201,
          body: { 'data' => created_attributes.merge('type' => 'spam complaint') }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      suppression = suppressions.create(request.merge(type: 'spam complaint'))

      expect(suppression.type).to eq('spam complaint')
    end

    context 'when invalid options are provided' do
      it 'raises ArgumentError' do
        expect { suppressions.create(request.merge(unknown_option: true)) }
          .to raise_error(ArgumentError, /invalid options are given/)
      end
    end

    it 'raises error when the request is rejected' do
      stub_request(:post, "#{base_url}/suppressions")
        .to_return(
          status: 422,
          body: { 'errors' => 'Email is invalid' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { suppressions.create(request) }.to raise_error(Mailtrap::Error)
    end
  end

  describe '#delete' do
    let(:suppression_id) { 1 }
    let(:deleted_attributes) do
      {
        'id' => '123e4567-e89b-12d3-a456-426614174000',
        'type' => 'hard bounce',
        'created_at' => '2024-06-01T12:00:00Z',
        'email' => 'user1@example.com',
        'sending_stream' => 'transactional',
        'domain_name' => 'example.com'
      }
    end

    it 'returns the deleted suppression' do
      stub_request(:delete, "#{base_url}/suppressions/#{suppression_id}")
        .to_return(
          status: 200,
          body: deleted_attributes.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      suppression = suppressions.delete(suppression_id)

      expect(suppression).to be_a(Mailtrap::Suppression)
      expect(suppression).to have_attributes(
        id: '123e4567-e89b-12d3-a456-426614174000',
        email: 'user1@example.com'
      )
    end

    it 'raises error when suppression not found' do
      stub_request(:delete, "#{base_url}/suppressions/999")
        .to_return(
          status: 404,
          body: { 'error' => 'Not Found' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { suppressions.delete(999) }.to raise_error(Mailtrap::Error)
    end

    it 'raises error when unauthorized' do
      stub_request(:delete, "#{base_url}/suppressions/#{suppression_id}")
        .to_return(
          status: 401,
          body: { 'error' => 'Unauthorized' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { suppressions.delete(suppression_id) }.to raise_error(Mailtrap::AuthorizationError)
    end
  end

  describe 'vcr#list', :vcr do
    subject(:list) { suppressions.list }

    it 'maps response data to Suppression objects' do
      expect(list).to all(be_a(Mailtrap::Suppression))
      expect(list.first).to have_attributes(
        id: be_a(String),
        type: be_a(String),
        created_at: be_a(String),
        email: be_a(String),
        sending_stream: be_a(String),
        domain_name: be_a(String),
        message_bounce_category: be_a(String),
        message_category: be_a(String),
        message_client_ip: be_a(String)
      )
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
end
