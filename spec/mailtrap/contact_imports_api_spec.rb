# frozen_string_literal: true

RSpec.describe Mailtrap::ContactImportsAPI do
  let(:imports_api) { described_class.new(123, Mailtrap::Client.new(api_key: 'correct-api-key')) }

  describe '#get' do
    it 'returns a specific contact import' do
      expected_response = {
        id: 1,
        status: 'finished',
        created_contacts_count: 10,
        updated_contacts_count: 2,
        contacts_over_limit_count: 0
      }
      stub_request(:get, %r{/api/accounts/123/contacts/imports/1})
        .to_return(
          status: 200,
          body: expected_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = imports_api.get(1)
      expect(response).to have_attributes(expected_response)
    end

    it 'raises error when contact import not found' do
      stub_request(:get, %r{/api/accounts/123/contacts/imports/1})
        .to_return(
          status: 404,
          body: { 'error' => 'Not Found' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { imports_api.get(1) }.to raise_error(Mailtrap::Error)
    end
  end

  describe '#create' do
    it 'creates a new contact import' do
      request = Mailtrap::ContactsImportRequest.new.tap do |req|
        req.upsert(email: 'j.doe@example.com', fields: { first_name: 'John' })
        req.add_to_lists(email: 'j.doe@example.com', list_ids: [1, 2])
        req.remove_from_lists(email: 'j.doe@example.com', list_ids: [3])
      end

      stub_request(:post, %r{/api/accounts/123/contacts/imports})
        .with(body: { contacts: request.to_a }.to_json)
        .to_return(
          status: 200,
          body: { id: 1, status: 'started' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = imports_api.create(request)
      expect(response).to have_attributes(
        id: 1,
        status: 'started',
        created_contacts_count: nil,
        updated_contacts_count: nil,
        contacts_over_limit_count: nil
      )

      response = imports_api.create(request.to_a)
      expect(response).to have_attributes(
        id: 1,
        status: 'started',
        created_contacts_count: nil,
        updated_contacts_count: nil,
        contacts_over_limit_count: nil
      )
    end

    it 'validates contacts' do
      expect { imports_api.create([{ email: 'john@example.com', foo: 1 }]) }.to raise_error(ArgumentError)
    end

    it 'handles api errors' do
      stub_request(:post, %r{/api/accounts/123/contacts/imports})
        .with(body: { contacts: [{ email: 'john@example' }] }.to_json)
        .to_return(
          status: 422,
          body: {
            'errors' => {
              'email' => 'john@example',
              'errors' => {
                'email' => ['is invalid']
              }
            }
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { imports_api.create([{ email: 'john@example' }]) }.to raise_error(Mailtrap::Error)
    end
  end
end
