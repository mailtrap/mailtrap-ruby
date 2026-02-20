# frozen_string_literal: true

RSpec.describe Mailtrap::SendingDomain do
  describe '#initialize' do
    subject(:sending_domain) { described_class.new(attributes) }

    let(:attributes) do
      {
        id: '123456',
        domain_name: 'My Sending Domain',
        dns_verified: false,
        compliance_status: 'pending',
        created_at: '2024-01-01T00:00:00Z',
        updated_at: '2024-01-02T00:00:00Z'
      }
    end

    it 'creates a sending domain with all attributes' do
      expect(sending_domain).to have_attributes(
        id: '123456',
        domain_name: 'My Sending Domain',
        dns_verified: false,
        compliance_status: 'pending',
        created_at: '2024-01-01T00:00:00Z',
        updated_at: '2024-01-02T00:00:00Z'
      )
    end
  end
end
