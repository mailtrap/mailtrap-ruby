# frozen_string_literal: true

RSpec.describe Mailtrap::CompanyInfo do
  describe '#initialize' do
    subject(:company_info) { described_class.new(attributes) }

    let(:attributes) do
      {
        name: 'Mailtrap',
        address: '123 Main St',
        city: 'San Francisco',
        country: 'US',
        phone: '+1-555-0100',
        zip_code: '94105',
        privacy_policy_url: 'https://mailtrap.io/privacy',
        terms_of_service_url: 'https://mailtrap.io/terms',
        website_url: 'https://mailtrap.io',
        info_level: 'business'
      }
    end

    it 'creates a company info with all attributes' do
      expect(company_info).to have_attributes(attributes)
    end
  end
end
