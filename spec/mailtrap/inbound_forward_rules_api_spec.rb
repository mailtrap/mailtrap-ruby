# frozen_string_literal: true

RSpec.describe Mailtrap::InboundForwardRulesAPI, :vcr do
  subject(:forward_rules_api) { described_class.new(client) }

  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }
  let(:inbox_id) { 3924 }
  let(:forward_rule_id) { 2 }

  describe '#list' do
    subject(:list) { forward_rules_api.list(inbox_id) }

    it 'maps response data to InboundForwardRule objects' do
      expect(list).to all(be_a(Mailtrap::InboundForwardRule))
    end
  end

  describe '#get' do
    subject(:get) { forward_rules_api.get(inbox_id, forward_rule_id) }

    it 'maps response data to an InboundForwardRule object' do
      expect(get).to be_a(Mailtrap::InboundForwardRule)
      expect(get).to have_attributes(id: forward_rule_id, name: be_a(String))
      expect(get.conditions).to all(be_a(Mailtrap::InboundForwardRuleCondition))
      expect(get.destinations).to all(be_a(Mailtrap::InboundForwardRuleDestination))
    end

    context 'when the forward rule does not exist' do
      let(:forward_rule_id) { -1 }

      it 'raises an error' do
        expect { get }.to raise_error(Mailtrap::Error)
      end
    end
  end

  describe '#create' do
    subject(:create) { forward_rules_api.create(inbox_id, options) }

    let(:options) do
      {
        name: 'Copy billing mail to finance',
        conditions: [{ match_type: 'sender', operator: 'ends_with', value: '@billing.example.com' }],
        destinations: [{ email: 'finance@example.com' }]
      }
    end

    it 'maps response data to an InboundForwardRule object' do
      expect(create).to be_a(Mailtrap::InboundForwardRule)
      expect(create).to have_attributes(name: 'Copy billing mail to finance')
      expect(create.destinations).to contain_exactly(be_a(Mailtrap::InboundForwardRuleDestination))
    end

    context 'when invalid options are provided' do
      let(:options) { { unsupported: 'value' } }

      it 'raises ArgumentError' do
        expect { create }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#update' do
    subject(:update) { forward_rules_api.update(inbox_id, forward_rule_id, options) }

    let(:options) { { destinations: [{ email: 'finance@example.com' }, { email: 'accounting@example.com' }] } }

    it 'maps response data to an InboundForwardRule object' do
      expect(update).to be_a(Mailtrap::InboundForwardRule)
      expect(update.destinations.size).to eq(2)
    end

    context 'when clearing conditions' do
      let(:options) { { conditions: [] } }

      it 'returns the rule without conditions' do
        expect(update.conditions).to eq([])
      end
    end

    context 'when invalid options are provided' do
      let(:options) { { unsupported: 'value' } }

      it 'raises ArgumentError' do
        expect { update }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#delete' do
    subject(:delete) { forward_rules_api.delete(inbox_id, forward_rule_id) }

    it 'returns nil' do
      expect(delete).to be_nil
    end

    context 'when the forward rule does not exist' do
      let(:forward_rule_id) { -1 }

      it 'raises an error' do
        expect { delete }.to raise_error(Mailtrap::Error)
      end
    end
  end
end
