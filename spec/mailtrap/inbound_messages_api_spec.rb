# frozen_string_literal: true

RSpec.describe Mailtrap::InboundMessagesAPI, :vcr do
  subject(:messages_api) { described_class.new(client) }

  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }
  let(:inbox_id) { 513 }
  let(:message_id) { '1871574677877796928' }

  describe '#list' do
    subject(:list) { messages_api.list(inbox_id) }

    it 'maps response data to an InboundMessagesListResponse' do
      expect(list).to be_a(Mailtrap::InboundMessagesListResponse)
      expect(list.data).to all(be_a(Mailtrap::InboundMessage))
      expect(list).to have_attributes(total_count: be_a(Integer))
    end

    context 'with pagination cursor' do
      subject(:list) { messages_api.list(inbox_id, last_id: '1700000000000000') }

      it 'passes last_id and returns a page' do
        expect(list).to be_a(Mailtrap::InboundMessagesListResponse)
      end
    end
  end

  describe '#get' do
    subject(:get) { messages_api.get(inbox_id, message_id) }

    it 'maps response data to an InboundMessage with attachments' do
      expect(get).to be_a(Mailtrap::InboundMessage)
      expect(get).to have_attributes(id: message_id, inbox_id: inbox_id)
      expect(get.attachments).to all(be_a(Mailtrap::InboundAttachment))
    end

    context 'when the message does not exist' do
      let(:message_id) { 'does-not-exist' }

      it 'raises an error' do
        expect { get }.to raise_error(Mailtrap::Error)
      end
    end
  end

  describe '#delete' do
    subject(:delete) { messages_api.delete(inbox_id, message_id) }

    it 'returns nil' do
      expect(delete).to be_nil
    end
  end

  describe '#reply' do
    subject(:reply) { messages_api.reply(inbox_id, message_id, options) }

    let(:options) { { text: 'Thanks for reaching out.' } }

    it 'maps response data to an InboundSendResult' do
      expect(reply).to be_a(Mailtrap::InboundSendResult)
      expect(reply.message_ids).to all(be_a(String))
    end

    context 'when invalid options are provided' do
      let(:options) { { unsupported: 'value' } }

      it 'raises ArgumentError' do
        expect { reply }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#reply_all' do
    subject(:reply_all) { messages_api.reply_all(inbox_id, message_id, { text: 'Looping everyone in.' }) }

    it 'maps response data to an InboundSendResult' do
      expect(reply_all).to be_a(Mailtrap::InboundSendResult)
    end
  end

  describe '#forward' do
    subject(:forward) { messages_api.forward(inbox_id, message_id, options) }

    let(:options) { { to: [{ email: 'colleague@example.com' }], text: 'Please take a look.' } }

    it 'maps response data to an InboundSendResult' do
      expect(forward).to be_a(Mailtrap::InboundSendResult)
    end

    context 'when no recipient is given' do
      let(:options) { { text: 'Please take a look.' } }

      it 'raises ArgumentError' do
        expect { forward }.to raise_error(ArgumentError, /to is required/)
      end
    end
  end
end
