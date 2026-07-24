# frozen_string_literal: true

RSpec.describe Mailtrap::InboundFolder do
  describe '#initialize' do
    subject(:folder) { described_class.new(id: 1, name: 'Support') }

    it 'creates a folder with all attributes' do
      expect(folder).to have_attributes(id: 1, name: 'Support')
    end
  end
end
