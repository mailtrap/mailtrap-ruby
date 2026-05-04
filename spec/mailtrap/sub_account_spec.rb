# frozen_string_literal: true

RSpec.describe Mailtrap::SubAccount do
  describe '#initialize' do
    subject(:sub_account) { described_class.new(attributes) }

    let(:attributes) { { id: 12_345, name: 'Development Team Account' } }

    it 'creates a sub account with all attributes' do
      expect(sub_account).to have_attributes(attributes)
    end
  end
end
