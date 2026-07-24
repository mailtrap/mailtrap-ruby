# frozen_string_literal: true

RSpec.describe Mailtrap::InboundInboxesAPI, :vcr do
  subject(:inboxes_api) { described_class.new(client) }

  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }
  let(:folder_id) { 77 }

  describe '#list' do
    subject(:list) { inboxes_api.list(folder_id) }

    it 'maps response data to InboundInbox objects' do
      expect(list).to all(be_a(Mailtrap::InboundInbox))
    end
  end

  describe '#get' do
    subject(:get) { inboxes_api.get(folder_id, inbox_id) }

    let(:inbox_id) { 473 }

    it 'maps response data to an InboundInbox object' do
      expect(get).to be_a(Mailtrap::InboundInbox)
      expect(get).to have_attributes(id: inbox_id, name: be_a(String), address: be_a(String))
    end

    context 'when the inbox does not exist' do
      let(:inbox_id) { -1 }

      it 'raises an error' do
        expect { get }.to raise_error(Mailtrap::Error)
      end
    end
  end

  describe '#create' do
    subject(:create) { inboxes_api.create(folder_id, options) }

    let(:options) { { name: 'Tickets' } }

    it 'maps response data to an InboundInbox object' do
      expect(create).to be_a(Mailtrap::InboundInbox)
      expect(create).to have_attributes(name: 'Tickets')
    end

    context 'when invalid options are provided' do
      let(:options) { { unsupported: 'value' } }

      it 'raises ArgumentError' do
        expect { create }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#update' do
    subject(:update) { inboxes_api.update(folder_id, inbox_id, options) }

    let(:inbox_id) { 513 }
    let(:options) { { name: 'Tickets (renamed)' } }

    it 'maps response data to an InboundInbox object' do
      expect(update).to be_a(Mailtrap::InboundInbox)
      expect(update).to have_attributes(id: inbox_id, name: 'Tickets (renamed)')
    end

    context 'when invalid options are provided' do
      let(:options) { { unsupported: 'value' } }

      it 'raises ArgumentError' do
        expect { update }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#delete' do
    subject(:delete) { inboxes_api.delete(folder_id, inbox_id) }

    let(:inbox_id) { 473 }

    it 'returns nil' do
      expect(delete).to be_nil
    end

    context 'when the inbox does not exist' do
      let(:inbox_id) { -1 }

      it 'raises an error' do
        expect { delete }.to raise_error(Mailtrap::Error)
      end
    end
  end
end
