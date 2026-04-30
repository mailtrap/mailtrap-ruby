# frozen_string_literal: true

RSpec.describe Mailtrap::ApiToken do
  describe '#initialize' do
    subject(:api_token) { described_class.new(attributes) }

    let(:attributes) do
      {
        id: 12_345,
        name: 'My API Token',
        last_4_digits: 'x7k9',
        created_by: 'user@example.com',
        expires_at: nil,
        resources: [{ resource_type: 'account', resource_id: 3229, access_level: 100 }],
        token: 'a1b2c3d4e5f6g7h8'
      }
    end

    it 'creates an api token with all attributes' do
      expect(api_token).to have_attributes(attributes)
    end
  end
end
