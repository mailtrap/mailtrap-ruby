# frozen_string_literal: true

RSpec.describe Mailtrap::InboundForwardRuleDestination do
  describe '#initialize' do
    subject(:destination) { described_class.new(email: 'finance@example.com') }

    it 'creates a destination with all attributes' do
      expect(destination).to have_attributes(email: 'finance@example.com')
    end
  end
end
