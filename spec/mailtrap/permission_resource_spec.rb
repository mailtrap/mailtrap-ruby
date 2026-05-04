# frozen_string_literal: true

RSpec.describe Mailtrap::PermissionResource do
  describe '#initialize' do
    subject(:resource) { described_class.new(attributes) }

    let(:child) do
      described_class.new(
        id: 3816,
        name: 'My First Inbox',
        type: 'inbox',
        access_level: 100,
        resources: []
      )
    end

    let(:attributes) do
      {
        id: 4001,
        name: 'My First Project',
        type: 'project',
        access_level: 1,
        resources: [child]
      }
    end

    it 'creates a permission resource with all attributes and nested children' do
      expect(resource).to have_attributes(
        id: 4001,
        name: 'My First Project',
        type: 'project',
        access_level: 1
      )
      expect(resource.resources).to eq([child])
    end
  end
end
