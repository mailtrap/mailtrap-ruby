# frozen_string_literal: true

RSpec.describe Mailtrap::SubAccountsAPI, :vcr do
  subject(:sub_accounts_api) { described_class.new(organization_id, client) }

  let(:organization_id) { ENV.fetch('MAILTRAP_ORGANIZATION_ID', 2_222_222) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_ORGANIZATION_API_KEY', 'local-org-api-key')) }

  describe '#initialize' do
    it 'raises ArgumentError when organization_id is nil' do
      expect { described_class.new(nil, client) }
        .to raise_error(ArgumentError, 'organization_id is required')
    end
  end

  describe '#list' do
    subject(:list) { sub_accounts_api.list }

    it 'maps response data to SubAccount objects' do
      expect(list).to all(be_a(Mailtrap::SubAccount))
      expect(list.first).to have_attributes(
        id: an_instance_of(Integer),
        name: an_instance_of(String)
      )
    end
  end

  describe '#create' do
    subject(:create) { sub_accounts_api.create(request) }

    let(:request) { { name: 'SDK Test Sub Account' } }

    it 'maps response data to SubAccount object' do
      expect(create).to be_a(Mailtrap::SubAccount)
      expect(create).to have_attributes(
        id: an_instance_of(Integer),
        name: 'SDK Test Sub Account'
      )
    end

    context 'when invalid options are provided' do
      let(:request) { { unknown_option: true } }

      it 'raises ArgumentError' do
        expect { create }.to raise_error(ArgumentError, /invalid options are given/)
      end
    end

    context 'when name is missing' do
      let(:request) { {} }

      it 'raises a Mailtrap::Error' do
        expect { create }.to raise_error(Mailtrap::Error)
      end
    end
  end
end
