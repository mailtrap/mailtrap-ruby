# frozen_string_literal: true

RSpec.describe Mailtrap::AccountAccess do
  subject(:account_access) { described_class.new(attributes) }

  let(:attributes) do
    {
      id: 123_456,
      specifier_type: 'User',
      specifier: { id: 789_012, email: 'example@mail.com' },
      resources: [
        {
          resource_id: 0,
          resource_type: 'account',
          access_level: 1000
        }
      ],
      permissions: {
        can_read: true,
        can_update: true,
        can_destroy: true,
        can_leave: true
      }
    }
  end

  describe '#initialize' do
    it 'creates a account_access with all attributes' do
      expect(account_access).to match_struct(
        id: 123_456,
        specifier_type: 'User',
        specifier: { id: 789_012, email: 'example@mail.com' },
        resources: [
          {
            resource_id: 0,
            resource_type: 'account',
            access_level: 1000
          }
        ],
        permissions: {
          can_read: true,
          can_update: true,
          can_destroy: true,
          can_leave: true
        }
      )
    end
  end
end
