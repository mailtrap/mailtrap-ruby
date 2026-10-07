# frozen_string_literal: true

RSpec.describe Mailtrap::InboundForwardOutcome do
  describe '#initialize' do
    subject(:outcome) do
      described_class.new(
        rule_id: 7,
        rule_name: 'Copy to support team',
        destination: 'team@example.com',
        status: 'rejected',
        reason: 'loop_prevention',
        message_id: nil
      )
    end

    it 'creates a forward outcome with all attributes' do
      expect(outcome).to have_attributes(
        rule_id: 7,
        rule_name: 'Copy to support team',
        destination: 'team@example.com',
        status: 'rejected',
        reason: 'loop_prevention',
        message_id: nil
      )
    end
  end
end
