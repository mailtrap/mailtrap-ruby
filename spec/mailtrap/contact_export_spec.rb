# frozen_string_literal: true

RSpec.describe Mailtrap::ContactExport do
  describe '#initialize' do
    subject(:contact_export) { described_class.new(attributes) }

    let(:attributes) do
      {
        id: 1,
        status: 'started',
        created_at: '2021-01-01T00:00:00Z',
        updated_at: '2021-01-01T00:00:00Z',
        url: nil
      }
    end

    it 'creates a contact export with all attributes' do
      expect(contact_export).to have_attributes(attributes)
    end
  end
end
