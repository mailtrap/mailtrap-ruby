# frozen_string_literal: true

RSpec.describe Mailtrap::CompanyInfoAPI, :vcr do
  subject(:company_info_api) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }
  let(:sending_domain_id) { 122_392 }

  describe '#create' do
    subject(:create) { company_info_api.create(sending_domain_id, request) }

    let(:request) do
      {
        name: 'Mailtrap',
        address: '123 Main St',
        city: 'San Francisco',
        country: 'US',
        zip_code: '94105',
        website_url: 'https://mailtrap.io',
        info_level: 'business'
      }
    end

    it 'maps response data to CompanyInfo object' do
      expect(create).to be_a(Mailtrap::CompanyInfo)
      expect(create).to have_attributes(
        name: 'Mailtrap',
        address: '123 Main St',
        city: 'San Francisco',
        country: 'US',
        zip_code: '94105',
        website_url: 'https://mailtrap.io',
        info_level: 'business'
      )
    end

    context 'when invalid options are provided' do
      let(:request) { { unknown_option: true } }

      it 'raises ArgumentError' do
        expect { create }.to raise_error(ArgumentError, /invalid options are given/)
      end
    end

    context 'when required field is missing' do
      let(:request) do
        {
          name: 'Mailtrap',
          address: '123 Main St',
          city: 'San Francisco',
          country: 'US',
          zip_code: '94105'
        }
      end

      it 'raises a Mailtrap::Error' do
        expect { create }.to raise_error(Mailtrap::Error) do |error|
          expect(error.message).to include('client error')
        end
      end
    end

    context 'when sending domain does not exist' do
      let(:sending_domain_id) { -1 }

      it 'raises not found error' do
        expect { create }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#update' do
    subject(:update) { company_info_api.update(sending_domain_id, request) }

    let(:request) do
      {
        city: 'New York',
        zip_code: '10001'
      }
    end

    it 'maps response data to CompanyInfo object' do
      expect(update).to be_a(Mailtrap::CompanyInfo)
      expect(update).to have_attributes(
        city: 'New York',
        zip_code: '10001'
      )
    end

    context 'when invalid options are provided' do
      let(:request) { { unknown_option: true } }

      it 'raises ArgumentError' do
        expect { update }.to raise_error(ArgumentError, /invalid options are given/)
      end
    end

    context 'when sending domain does not exist' do
      let(:sending_domain_id) { -1 }

      it 'raises not found error' do
        expect { update }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end
end
