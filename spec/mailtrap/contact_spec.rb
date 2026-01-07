# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mailtrap::Contact do
  subject(:contact) { described_class.new(attributes) }

  let(:attributes) do
    {
      id: '123',
      email: 'test@example.com',
      fields: { name: 'Test User' },
      list_ids: [1, 2],
      status: 'subscribed',
      created_at: 1_700_000_000,
      updated_at: 1_700_000_100
    }
  end

  describe '#newly_created?' do
    it { is_expected.to be_newly_created }

    context "when action is 'created'" do
      let(:attributes) { super().merge(action: 'created') }

      it { is_expected.to be_newly_created }
    end

    context "when action is 'updated'" do
      let(:attributes) { super().merge(action: 'updated') }

      it { is_expected.not_to be_newly_created }
    end
  end
end
