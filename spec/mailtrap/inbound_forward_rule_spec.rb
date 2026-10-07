# frozen_string_literal: true

RSpec.describe Mailtrap::InboundForwardRule do
  describe '#initialize' do
    subject(:forward_rule) do
      described_class.new(
        id: 7,
        name: 'Copy billing mail to finance',
        created_at: '2026-05-08T10:30:00.000Z',
        updated_at: '2026-05-08T12:15:00.000Z',
        conditions: [condition],
        destinations: [destination]
      )
    end

    let(:condition) do
      Mailtrap::InboundForwardRuleCondition.new(
        match_type: 'sender', operator: 'ends_with', value: '@billing.example.com', header_key: nil
      )
    end
    let(:destination) { Mailtrap::InboundForwardRuleDestination.new(email: 'finance@example.com') }

    it 'creates a forward rule with all attributes' do
      expect(forward_rule).to have_attributes(
        id: 7,
        name: 'Copy billing mail to finance',
        created_at: '2026-05-08T10:30:00.000Z',
        updated_at: '2026-05-08T12:15:00.000Z',
        conditions: [have_attributes(match_type: 'sender', operator: 'ends_with', value: '@billing.example.com')],
        destinations: [have_attributes(email: 'finance@example.com')]
      )
    end
  end
end
