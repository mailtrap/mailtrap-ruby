# frozen_string_literal: true

RSpec.describe Mailtrap::InboundSendResult do
  describe '#initialize' do
    subject(:result) do
      described_class.new(message_ids: ['1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d'])
    end

    it 'creates a send result with all attributes' do
      expect(result).to have_attributes(
        message_ids: ['1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d']
      )
    end
  end
end
