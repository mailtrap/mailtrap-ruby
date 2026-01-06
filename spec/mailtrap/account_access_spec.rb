# frozen_string_literal: true

RSpec.describe Mailtrap::AccountAccess do
  describe '#initialize' do
    subject(:account_access) { described_class.new(attributes) }

    let(:attributes) do
      {
        id: 42,
        specifier_type: "User",
        specifier: {
          "id": 1,
          "email": "name@gmail.com",
          "name": "text",
          "two_factor_authentication_enabled": true
        },
        resources: [
          {
            "resource_id": 1,
            "resource_type": "account",
            "access_level": 1000
          }
        ],
        permissions: {
          "can_read": true,
          "can_update": true,
          "can_destroy": true,
          "can_leave": true
        }
      }
    end

    it 'creates an account access with all attributes' do
      expect(account_access).to match_struct(
        id: 42,
        specifier_type: "User",
        specifier: {
          "id": 1,
          "email": "name@gmail.com",
          "name": "text",
          "two_factor_authentication_enabled": true
        },
        resources: [
          {
            "resource_id": 1,
            "resource_type": "account",
            "access_level": 1000
          }
        ],
        permissions: {
          "can_read": true,
          "can_update": true,
          "can_destroy": true,
          "can_leave": true
        }
      )
    end
  end

  describe '#to_h' do
    subject(:hash) { account_access.to_h }

    let(:account_access) do
      described_class.new(
        id: 42,
        specifier_type: "User",
        specifier: {
          "id": 1,
          "email": "name@gmail.com",
          "name": "text",
          "two_factor_authentication_enabled": true
        },
        resources: [
          {
            "resource_id": 1,
            "resource_type": "account",
            "access_level": 1000
          }
        ],
        permissions: {
          "can_read": true,
          "can_update": true,
          "can_destroy": true,
          "can_leave": true
        }
      )
    end

    it 'returns a hash with all attributes' do
      expect(hash).to eq(
        id: 42,
        specifier_type: "User",
        specifier: {
          "id": 1,
          "email": "name@gmail.com",
          "name": "text",
          "two_factor_authentication_enabled": true
        },
        resources: [
          {
            "resource_id": 1,
            "resource_type": "account",
            "access_level": 1000
          }
        ],
        permissions: {
          "can_read": true,
          "can_update": true,
          "can_destroy": true,
          "can_leave": true
        }
      )
    end
  end
end
