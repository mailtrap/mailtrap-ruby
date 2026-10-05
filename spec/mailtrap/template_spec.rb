# frozen_string_literal: true

RSpec.describe Mailtrap::Template do
  describe '#initialize' do
    subject(:template) { described_class.new(attributes) }

    let(:attributes) do
      {
        id: 26_730,
        uuid: '018dd5e3-f6d2-7c00-8f9b-e5c3f2d8a132',
        name: 'My Template',
        subject: 'My Subject',
        category: 'My Category',
        body_html: '<div>HTML</div>',
        body_text: 'Text',
        created_at: '2021-01-01T00:00:00Z',
        updated_at: '2021-01-01T00:00:00Z'
      }
    end

    it 'creates a template with all attributes' do
      expect(template).to have_attributes(attributes)
    end
  end

  describe Mailtrap::TemplatesListResponse do
    subject(:response) { described_class.new(data: [template], pagination: { token: 1 }) }

    let(:template) { Mailtrap::Template.new(id: 1) }

    it 'exposes the page and its pagination' do
      expect(response).to have_attributes(data: [template], pagination: { token: 1 })
    end
  end
end
