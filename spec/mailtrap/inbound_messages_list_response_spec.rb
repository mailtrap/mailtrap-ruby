# frozen_string_literal: true

RSpec.describe Mailtrap::InboundMessagesListResponse do
  describe '#initialize' do
    subject(:response) do
      described_class.new(data: [], total_count: 0, last_id: nil)
    end

    it 'creates a list response with all attributes' do
      expect(response).to have_attributes(data: [], total_count: 0, last_id: nil)
    end
  end
end
