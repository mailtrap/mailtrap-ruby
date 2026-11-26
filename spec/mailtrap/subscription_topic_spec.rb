# frozen_string_literal: true

RSpec.describe Mailtrap::SubscriptionTopic do
  describe '#initialize' do
    subject(:topic) { described_class.new(attributes) }

    let(:attributes) do
      {
        id: 12,
        name: 'Product updates',
        description: nil,
        domain_id: 4321,
        deleted_at: '2026-11-10T10:00:00Z',
        created_at: '2026-11-01T10:00:00Z',
        updated_at: '2026-11-10T10:00:00Z'
      }
    end

    it 'creates a subscription topic with all attributes' do
      expect(topic).to have_attributes(attributes)
    end
  end

  describe Mailtrap::SubscriptionTopicsListResponse do
    subject(:response) { described_class.new(data: [topic], pagination: { token: 1 }) }

    let(:topic) { Mailtrap::SubscriptionTopic.new(id: 12) }

    it 'exposes the page and its pagination' do
      expect(response).to have_attributes(data: [topic], pagination: { token: 1 })
    end
  end
end
