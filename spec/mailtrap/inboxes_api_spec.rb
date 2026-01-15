# frozen_string_literal: true

RSpec.describe Mailtrap::InboxesAPI, :vcr do
  subject(:inboxes_api) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }

  describe '#list' do
    subject(:list) { inboxes_api.list }

    it 'maps response data to Inboxes objects' do
      expect(list).to all(be_a(Mailtrap::Inbox))
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
    subject(:get) { inboxes_api.get(inbox_id) }

    let(:inbox_id) { 4_278_175 }

    it 'maps response data to Inbox object' do
      expect(get).to be_a(Mailtrap::Inbox)
      expect(get).to have_attributes(
        id: inbox_id,
        name: 'Test Inbox'
      )
    end

    context 'when inbox does not exist' do
      let(:inbox_id) { -1 }

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
    subject(:create) { inboxes_api.create(**request) }

    let(:request) do
      {
        name: 'Test Inbox',
        project_id: 2_379_735
      }
    end

    it 'maps response data to Inbox object' do
      expect(create).to be_a(Mailtrap::Inbox)
      expect(create).to have_attributes(
        name: 'Test Inbox'
      )
    end

    context 'when API returns an error' do
      let(:request) do
        {
          name: '', # Invalid value, but present
          project_id: 2_379_735
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

  describe '#update' do
    subject(:update) { inboxes_api.update(inbox_id, **request) }

    let(:inbox_id) { 4_278_175 }

    let(:request) do
      {
        name: 'Updated Inbox',
        email_username: 'updated_username'
      }
    end

    it 'maps response data to Inbox object' do
      expect(update).to be_a(Mailtrap::Inbox)
      expect(update).to have_attributes(
        name: 'Updated Inbox',
        email_username: '1234abcd'
      )
    end

    context 'with hash request' do
      let(:request) do
        {
          name: 'Updated Inbox'
        }
      end

      it 'maps response data to Inbox object' do
        expect(update).to be_a(Mailtrap::Inbox)
        expect(update).to have_attributes(
          name: 'Updated Inbox'
        )
      end
    end

    context 'when inbox does not exist' do
      let(:inbox_id) { -1 }

      it 'raises not found error' do
        expect { update }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#clean' do
    subject(:clean) { inboxes_api.clean(inbox_id) }

    let(:inbox_id) { 4_278_175 }

    it 'cleans Inbox and returns Inbox object' do
      expect(clean).to have_attributes(
        id: inbox_id,
        name: 'Updated Inbox'
      )
    end

    context 'when inbox does not exist' do
      let(:inbox_id) { -1 }

      it 'raises not found error' do
        expect { clean }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#mark_as_read' do
    subject(:mark_as_read) { inboxes_api.mark_as_read(inbox_id) }

    let(:inbox_id) { 4_278_175 }

    it 'returns nil' do
      expect(mark_as_read).to have_attributes(
        id: inbox_id,
        name: 'Updated Inbox'
      )
    end

    context 'when inbox does not exist' do
      let(:inbox_id) { -1 }

      it 'raises not found error' do
        expect { mark_as_read }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#reset_credentials' do
    subject(:reset_credentials) { inboxes_api.reset_credentials(inbox_id) }

    let(:inbox_id) { 4_278_175 }

    it 'returns nil' do
      expect(reset_credentials).to have_attributes(
        id: inbox_id,
        name: 'Updated Inbox'
      )
    end

    context 'when inbox does not exist' do
      let(:inbox_id) { -1 }

      it 'raises not found error' do
        expect { reset_credentials }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#delete' do
    subject(:delete) { inboxes_api.delete(inbox_id) }

    let(:inbox_id) { 4_278_175 }

    it 'returns deleted inbox data' do
      expect(delete).to include(
        id: inbox_id,
        name: 'Updated Inbox'
      )
    end

    context 'when inbox does not exist' do
      let(:inbox_id) { -1 }

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
