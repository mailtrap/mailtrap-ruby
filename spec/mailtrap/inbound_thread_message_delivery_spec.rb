# frozen_string_literal: true

RSpec.describe Mailtrap::InboundThreadMessageDelivery do
  describe '#initialize' do
    subject(:delivery) do
      described_class.new(
        to: 'customer@example.com',
        status: 'delivered',
        delivered_at: '2026-05-08T11:40:05.000Z',
        bounced_at: nil
      )
    end

    it 'creates a delivery with all attributes' do
      expect(delivery).to have_attributes(
        to: 'customer@example.com',
        status: 'delivered',
        delivered_at: '2026-05-08T11:40:05.000Z',
        bounced_at: nil
      )
    end
  end
end
