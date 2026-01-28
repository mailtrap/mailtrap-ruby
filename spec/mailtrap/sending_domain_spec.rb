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

  describe '#to_h' do
    subject(:hash) { sending_domain.to_h }

    let(:project) do
      described_class.new(
        id: '123456',
        domain_name: 'My Sending Domain',
        dns_verified: false,
        compliance_status: 'pending',
        created_at: '2024-01-01T00:00:00Z',
        updated_at: '2024-01-02T00:00:00Z'
      )
    end

    context 'when some attributes are nil' do
      let(:sending_domain) do
        described_class.new(
          id: '123456',
          domain_name: 'My Sending Domain',
          dns_verified: nil,
          compliance_status: nil,
          created_at: '2024-01-01T00:00:00Z',
          updated_at: '2024-01-02T00:00:00Z'
        )
      end

      it 'returns a hash with only non-nil attributes' do
        expect(hash).to eq(
          id: '123456',
          domain_name: 'My Sending Domain',
          created_at: '2024-01-01T00:00:00Z',
          updated_at: '2024-01-02T00:00:00Z'
        )
      end
    end
  end
end
