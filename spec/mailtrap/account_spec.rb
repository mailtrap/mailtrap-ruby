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

  describe '#to_h' do
    subject(:hash) { account.to_h }

    let(:account) do
      described_class.new(
        id: '123456',
        name: 'Account 1',
        access_levels: [
          1000
        ]
      )
    end

    it 'returns a hash with all attributes' do
      expect(hash).to eq(
        id: '123456',
        name: 'Account 1',
        access_levels: [1000]
      )
    end

    context 'when some attributes are nil' do
      let(:account) do
        described_class.new(
          id: '123456'
        )
      end

      it 'returns a hash with only non-nil attributes' do
        expect(hash).to eq(
          id: '123456'
        )
      end
    end
  end
end
