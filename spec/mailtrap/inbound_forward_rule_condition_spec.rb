# frozen_string_literal: true

RSpec.describe Mailtrap::InboundForwardRuleCondition do
  describe '#initialize' do
    subject(:condition) do
      described_class.new(match_type: 'header', operator: 'equal', value: 'high', header_key: 'X-Priority-Level')
    end

    it 'creates a condition with all attributes' do
      expect(condition).to have_attributes(
        match_type: 'header',
        operator: 'equal',
        value: 'high',
        header_key: 'X-Priority-Level'
      )
    end
  end
end
