# frozen_string_literal: true

RSpec.describe Mailtrap::EmailLogsAPI, :vcr do
  subject(:email_logs) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }

  describe '#list' do
    subject(:list) { email_logs.list }

    it 'maps response data to EmailLogsListResponse with messages' do
      expect(list.total_count).to eq(1)
      expect(list.next_page_cursor).to be_nil
      expect(list.messages).to all(be_a(Mailtrap::EmailLogMessage))
      expect(list.messages.first).to have_attributes(
        message_id: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        status: 'delivered',
        subject: 'Test Subject',
        from: 'sender@example.com',
        to: 'recipient@example.com',
        sent_at: '2025-01-15T10:30:00Z',
        client_ip: '192.0.2.1',
        category: 'Test Category',
        sending_stream: 'transactional',
        sending_domain_id: 3938,
        raw_message_url: nil,
        opens_count: 0,
        clicks_count: 0,
        events: nil
      )
    end

    context 'with filters and search_after' do
      subject(:list) do
        email_logs.list(
          filters: {
            sent_after: '2025-01-01T00:00:00Z',
            sent_before: '2025-01-31T23:59:59Z',
            subject: { operator: 'not_empty' },
            to: { operator: 'ci_equal', value: 'recipient@example.com' },
            category: { operator: 'equal', value: ['Test Category', 'Another Category'] }
          },
          search_after: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
        )
      end

      it 'sends correct query params and maps response data to EmailLogsListResponse with messages' do
        allow(client).to receive(:get).and_call_original

        expect(list).to be_a(Mailtrap::EmailLogsListResponse)
        expect(list.messages).to all(be_a(Mailtrap::EmailLogMessage))

        expect(client).to have_received(:get).with(
          '/api/accounts/1111111/email_logs',
          {
            'filters[category][operator]' => 'equal',
            'filters[category][value][]' => ['Test Category', 'Another Category'],
            'filters[sent_after]' => '2025-01-01T00:00:00Z',
            'filters[sent_before]' => '2025-01-31T23:59:59Z',
            'filters[subject][operator]' => 'not_empty',
            'filters[to][operator]' => 'ci_equal',
            'filters[to][value]' => 'recipient@example.com',
            search_after: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
          }
        )
      end
    end
  end

  describe '#list_each' do
    let(:filters) { { sent_after: '2025-01-01T00:00:00Z' } }

    let(:first_page_message) do
      Mailtrap::EmailLogMessage.new(
        message_id: 'page1-msg',
        status: 'delivered',
        from: 'a@b.com',
        to: 'c@d.com',
        sent_at: '2025-01-01T00:00:00Z',
        sending_stream: 'transactional',
        sending_domain_id: 1,
        opens_count: 0,
        clicks_count: 0
      )
    end

    let(:second_page_message) do
      Mailtrap::EmailLogMessage.new(
        message_id: 'page2-msg',
        status: 'delivered',
        from: 'a@b.com',
        to: 'c@d.com',
        sent_at: '2025-01-01T00:00:00Z',
        sending_stream: 'transactional',
        sending_domain_id: 1,
        opens_count: 0,
        clicks_count: 0
      )
    end

    before do
      first_page = Mailtrap::EmailLogsListResponse.new(
        messages: [first_page_message],
        total_count: 2,
        next_page_cursor: 'page1-msg'
      )
      second_page = Mailtrap::EmailLogsListResponse.new(
        messages: [second_page_message],
        total_count: 2,
        next_page_cursor: nil
      )

      allow(email_logs).to receive(:list).and_return(first_page, second_page) # rubocop:disable RSpec/SubjectStub
    end

    it 'returns enumerator without block and calls list for each page when iterated' do
      enum = email_logs.list_each(filters: filters)
      expect(enum).to be_an(Enumerator)

      messages = enum.to_a
      expect(messages).to eq([first_page_message, second_page_message])

      # rubocop:disable RSpec/SubjectStub
      expect(email_logs).to have_received(:list).with(filters: filters, search_after: nil)
      expect(email_logs).to have_received(:list).with(filters: filters, search_after: 'page1-msg')
      # rubocop:enable RSpec/SubjectStub
    end

    it 'yields each message from all pages when block given' do
      expect { |probe| email_logs.list_each(filters: filters, &probe) }.to yield_successive_args(
        first_page_message,
        second_page_message
      )

      # rubocop:disable RSpec/SubjectStub
      expect(email_logs).to have_received(:list).with(filters: filters, search_after: nil)
      expect(email_logs).to have_received(:list).with(filters: filters, search_after: 'page1-msg')
      # rubocop:enable RSpec/SubjectStub
    end
  end

  describe '#get' do
    subject(:message) { email_logs.get(message_id) }

    let(:message_id) { 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' }

    it 'maps response data to EmailLogMessage with events and raw_message_url' do # rubocop:disable RSpec/MultipleExpectations
      expect(message).to be_a(Mailtrap::EmailLogMessage)
      expect(message).to have_attributes(
        message_id: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        status: 'delivered',
        subject: 'Test Subject',
        from: 'sender@example.com',
        to: 'recipient@example.com',
        sent_at: '2025-01-15T10:30:00Z',
        client_ip: '192.0.2.1',
        category: 'Test Category',
        sending_stream: 'transactional',
        sending_domain_id: 3938,
        raw_message_url: 'https://example.com/raw/test-message.eml',
        opens_count: 0,
        clicks_count: 0
      )
      expect(message.events).to all(be_a(Mailtrap::EmailLogEvent))
      expect(message.events.first).to have_attributes(
        event_type: 'delivery',
        created_at: '2025-01-15T10:30:01Z'
      )
      expect(message.events.first.details).to be_a(Mailtrap::EmailLogEventDetails::Delivery)
      expect(message.events.first.details).to have_attributes(
        sending_ip: '192.0.2.2',
        recipient_mx: 'mx.example.com',
        email_service_provider: 'Example Provider'
      )
    end

    context 'when message not found' do
      let(:message_id) { '00000000-0000-0000-0000-000000000000' }

      it 'raises error' do
        expect { message }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end
end
