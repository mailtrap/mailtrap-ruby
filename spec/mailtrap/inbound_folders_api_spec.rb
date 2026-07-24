# frozen_string_literal: true

RSpec.describe Mailtrap::InboundFoldersAPI, :vcr do
  subject(:folders_api) { described_class.new(client) }

  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }

  describe '#list' do
    subject(:list) { folders_api.list }

    it 'maps response data to InboundFolder objects' do
      expect(list).to all(be_a(Mailtrap::InboundFolder))
    end
  end

  describe '#get' do
    subject(:get) { folders_api.get(folder_id) }

    let(:folder_id) { 1 }

    it 'maps response data to an InboundFolder object' do
      expect(get).to be_a(Mailtrap::InboundFolder)
      expect(get).to have_attributes(id: folder_id, name: be_a(String))
    end

    context 'when the folder does not exist' do
      let(:folder_id) { -1 }

      it 'raises an error' do
        expect { get }.to raise_error(Mailtrap::Error)
      end
    end
  end

  describe '#create' do
    subject(:create) { folders_api.create(options) }

    let(:options) { { name: 'Support' } }

    it 'maps response data to an InboundFolder object' do
      expect(create).to be_a(Mailtrap::InboundFolder)
      expect(create).to have_attributes(name: 'Support')
    end

    context 'when invalid options are provided' do
      let(:options) { { unsupported: 'value' } }

      it 'raises ArgumentError' do
        expect { create }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#update' do
    subject(:update) { folders_api.update(folder_id, options) }

    let(:folder_id) { 1 }
    let(:options) { { name: 'Customer Success' } }

    it 'maps response data to an InboundFolder object' do
      expect(update).to be_a(Mailtrap::InboundFolder)
      expect(update).to have_attributes(id: folder_id, name: 'Customer Success')
    end

    context 'when invalid options are provided' do
      let(:options) { { unsupported: 'value' } }

      it 'raises ArgumentError' do
        expect { update }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#delete' do
    subject(:delete) { folders_api.delete(folder_id) }

    let(:folder_id) { 1 }

    it 'returns nil' do
      expect(delete).to be_nil
    end

    context 'when the folder does not exist' do
      let(:folder_id) { -1 }

      it 'raises an error' do
        expect { delete }.to raise_error(Mailtrap::Error)
      end
    end
  end
end
