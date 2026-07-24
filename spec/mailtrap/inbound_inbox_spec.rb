# frozen_string_literal: true

RSpec.describe Mailtrap::InboundInbox do
  describe '#initialize' do
    subject(:inbox) do
      described_class.new(
        id: 42,
        name: 'Tickets',
        address: 'tickets-1a2b3c4d@inbound-mailtrap.io',
        domain_id: 892
      )
    end

    it 'creates an inbox with all attributes' do
      expect(inbox).to have_attributes(
        id: 42,
        name: 'Tickets',
        address: 'tickets-1a2b3c4d@inbound-mailtrap.io',
        domain_id: 892
      )
    end
  end
end
