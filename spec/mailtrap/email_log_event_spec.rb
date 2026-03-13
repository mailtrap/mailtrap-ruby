# frozen_string_literal: true

RSpec.describe Mailtrap::EmailLogEvent do
  let(:attributes) do
    {
      event_type: 'click',
      created_at: '2025-01-15T10:35:00Z',
      details: { click_url: 'https://example.com/track/abc', web_ip_address: '198.51.100.50' }
    }
  end

  describe '#initialize' do
    subject(:event) { described_class.new(attributes) }

    it 'creates an event with all attributes' do
      expect(event).to have_attributes(attributes)
    end
  end
end
