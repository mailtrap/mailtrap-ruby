# frozen_string_literal: true

RSpec.describe Mailtrap::InboundThreadMessageDelivery do
  describe '#initialize' do
    subject(:delivery) do
      described_class.new(
        to: 'customer@example.com',
        status: 'delivered',
        delivered_at: '2026-05-08T11:40:05.000Z',
        bounced_at: nil,
        rejected_at: nil
      )
    end

    it 'creates a delivery with all attributes' do
      expect(delivery).to have_attributes(
        to: 'customer@example.com',
        status: 'delivered',
        delivered_at: '2026-05-08T11:40:05.000Z',
        bounced_at: nil,
        rejected_at: nil
      )
    end

    context 'when the message was rejected before sending' do
      subject(:delivery) do
        described_class.new(
          to: 'suppressed@example.com',
          status: 'not_delivered',
          delivered_at: nil,
          bounced_at: nil,
          rejected_at: '2026-05-08T11:40:01.000Z'
        )
      end

      it 'keeps the rejection timestamp' do
        expect(delivery).to have_attributes(
          status: 'not_delivered',
          delivered_at: nil,
          rejected_at: '2026-05-08T11:40:01.000Z'
        )
      end
    end
  end
end
