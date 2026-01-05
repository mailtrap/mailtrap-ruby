# frozen_string_literal: true

RSpec.describe Mailtrap::SandboxAttachmentsAPI, :vcr do
  subject(:sandbox_attachments_api) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }
  let(:inbox_id) { ENV.fetch('MAILTRAP_INBOX_ID', 4_288_340) }
  let(:message_id) { ENV.fetch('MAILTRAP_SANDBOX_MESSAGE_ID', 5_274_457_639) }

  describe '#list' do
    subject(:list) { sandbox_attachments_api.list(inbox_id, message_id) }

    it 'maps response data to SandboxAttachment objects' do
      expect(list).to all(be_a(Mailtrap::SandboxAttachment))
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
    subject(:get) { sandbox_attachments_api.get(inbox_id, message_id, attachment_id) }

    let(:attachment_id) { 790_295_400 }

    it 'maps response data to SandboxAttachment object' do
      expect(get).to be_a(Mailtrap::SandboxAttachment)
      expect(get).to have_attributes(
        id: attachment_id,
        filename: 'example_2.txt'
      )
    end

    context 'when attachment does not exist' do
      let(:attachment_id) { -1 }

      it 'raises not found error' do
        expect { get }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end
end
