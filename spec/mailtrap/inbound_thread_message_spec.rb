# frozen_string_literal: true

RSpec.describe Mailtrap::InboundThreadMessage do
  describe '#initialize' do
    subject(:thread_message) do
      described_class.new(
        visibility_status: 'available',
        direction: 'outbound',
        id: '1700000000000125',
        subject: 'Re: Question',
        delivery:
      )
    end

    let(:delivery) do
      Mailtrap::InboundThreadMessageDelivery.new(
        to: 'customer@example.com', status: 'delivered', delivered_at: '2026-01-15T10:31:00Z', bounced_at: nil
      )
    end

    it 'creates a thread message with all attributes' do
      expect(thread_message).to have_attributes(
        visibility_status: 'available',
        direction: 'outbound',
        id: '1700000000000125',
        subject: 'Re: Question',
        delivery: have_attributes(to: 'customer@example.com', status: 'delivered')
      )
    end
  end
end
