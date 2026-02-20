# frozen_string_literal: true

RSpec.describe Mailtrap::Account do
  describe '#initialize' do
    subject(:account) { described_class.new(attributes) }

    let(:attributes) do
      {
        id: '123456',
        name: 'Account 1',
        access_levels: [
          1000
        ]
      }
    end

    it 'creates a project with all attributes' do
      expect(account).to match_struct(
        id: '123456',
        name: 'Account 1',
        access_levels: [1000]
      )
    end
  end
end
