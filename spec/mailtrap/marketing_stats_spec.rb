# frozen_string_literal: true

RSpec.describe Mailtrap::MarketingStats do
  describe '#initialize' do
    subject(:marketing_stats) { described_class.new(attributes) }

    let(:attributes) do
      {
        delivery_count: 1200,
        delivery_rate: 0.96,
        bounce_count: 50,
        bounce_rate: 0.04,
        open_count: 600,
        open_rate: 0.5,
        click_count: 240,
        click_rate: 0.2,
        spam_count: 3,
        spam_rate: 0.0025,
        unsubscription_count: 12,
        unsubscription_rate: 0.01,
        sent_count: 1250
      }
    end

    it 'creates marketing stats with all attributes' do
      expect(marketing_stats).to match_struct(attributes)
    end
  end
end
