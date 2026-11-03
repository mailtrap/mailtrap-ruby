# frozen_string_literal: true

RSpec.describe Mailtrap::Domain do
  describe '#initialize' do
    subject(:domain) { described_class.new(attributes) }

    let(:attributes) do
      {
        id: '123456',
        domain_name: 'My Domain',
        dns_verified: false,
        compliance_status: 'pending',
        created_at: '2024-01-01T00:00:00Z',
        updated_at: '2024-01-02T00:00:00Z'
      }
    end

    it 'creates a domain with all attributes' do
      expect(domain).to have_attributes(
        id: '123456',
        domain_name: 'My Domain',
        dns_verified: false,
        compliance_status: 'pending',
        created_at: '2024-01-01T00:00:00Z',
        updated_at: '2024-01-02T00:00:00Z'
      )
    end
  end

  describe 'deprecated Mailtrap::SendingDomain alias', :ruby_deprecation_warnings do
    it 'is Domain and warns when deprecation warnings are enabled' do
      constant = nil

      expect { constant = Mailtrap::SendingDomain }
        .to output(/constant Mailtrap::SendingDomain is deprecated/).to_stderr
      expect(constant).to be(described_class)
    end
  end
end
