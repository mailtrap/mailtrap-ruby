# frozen_string_literal: true

RSpec.describe Mailtrap::ContactExportsAPI, :vcr do
  subject(:contact_exports_api) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }

  describe '#create' do
    subject(:create) { contact_exports_api.create(request) }

    let(:request) do
      {
        filters: [
          { name: 'list_id', operator: 'equal', value: [1, 2] }
        ]
      }
    end

    it 'maps response data to ContactExport object' do
      expect(create).to be_a(Mailtrap::ContactExport)
      expect(create).to have_attributes(
        id: an_instance_of(Integer),
        status: 'created',
        url: nil
      )
    end

    context 'when invalid options are provided' do
      let(:request) { { unknown_option: true } }

      it 'raises ArgumentError' do
        expect { create }.to raise_error(ArgumentError, /invalid options are given/)
      end
    end

    context 'when filters are malformed' do
      let(:request) { { filters: 'invalid' } }

      it 'raises a Mailtrap::Error' do
        expect { create }.to raise_error(Mailtrap::Error)
      end
    end
  end
end
