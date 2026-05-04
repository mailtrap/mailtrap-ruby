# frozen_string_literal: true

RSpec.describe Mailtrap::ContactEvent do
  describe '#initialize' do
    subject(:contact_event) { described_class.new(attributes) }

    let(:attributes) do
      {
        contact_id: '0199090c-b5ec-7be8-b18f-1a7c8a64f9fb',
        contact_email: 'john.smith@example.com',
        name: 'UserLogin',
        params: { 'user_id' => 101, 'is_active' => true }
      }
    end

    it 'creates a contact event with all attributes' do
      expect(contact_event).to have_attributes(attributes)
    end
  end
end
