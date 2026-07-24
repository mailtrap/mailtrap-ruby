# frozen_string_literal: true

RSpec.describe Mailtrap::InboundThreadsAPI, :vcr do
  subject(:threads_api) { described_class.new(client) }

  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }
  let(:inbox_id) { 513 }
  let(:thread_id) { '1871574677878845504' }

  describe '#list' do
    subject(:list) { threads_api.list(inbox_id) }

    it 'maps response data to an InboundThreadsListResponse' do
      expect(list).to be_a(Mailtrap::InboundThreadsListResponse)
      expect(list.data).to all(be_a(Mailtrap::InboundThread))
      expect(list).to have_attributes(total_count: be_a(Integer))
    end

    context 'with pagination cursor' do
      subject(:list) { threads_api.list(inbox_id, last_id: 'abc123') }

      it 'passes last_id and returns a page' do
        expect(list).to be_a(Mailtrap::InboundThreadsListResponse)
      end
    end
  end

  describe '#get' do
    subject(:get) { threads_api.get(inbox_id, thread_id) }

    it 'maps response data to an InboundThread with messages' do
      expect(get).to be_a(Mailtrap::InboundThread)
      expect(get).to have_attributes(id: thread_id)
      expect(get.messages).to all(be_a(Mailtrap::InboundThreadMessage))
    end

    context 'when the thread does not exist' do
      let(:thread_id) { 'does-not-exist' }

      it 'raises an error' do
        expect { get }.to raise_error(Mailtrap::Error)
      end
    end
  end

  describe '#delete' do
    subject(:delete) { threads_api.delete(inbox_id, thread_id) }

    it 'returns nil' do
      expect(delete).to be_nil
    end

    context 'when the thread does not exist' do
      let(:thread_id) { 'does-not-exist' }

      it 'raises an error' do
        expect { delete }.to raise_error(Mailtrap::Error)
      end
    end
  end
end
