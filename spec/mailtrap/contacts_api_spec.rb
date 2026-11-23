# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mailtrap::ContactsAPI do
  let(:client) { described_class.new('1111111', Mailtrap::Client.new(api_key: 'correct-api-key')) }
  let(:base_url) { 'https://mailtrap.io/api/accounts/1111111' }
  let(:email) { 'test@example.com' }
  let(:contact_id) { '019706a8-9612-77be-8586-4f26816b467a' }

  describe '#get' do
    context 'when contact_id is a UUID' do
      let(:expected_response) do
        {
          'data' => {
            'id' => contact_id,
            'email' => email,
            'created_at' => 1_748_163_401_202,
            'updated_at' => 1_748_163_401_202,
            'list_ids' => [1, 2],
            'status' => 'subscribed',
            'fields' => {
              'first_name' => 'John',
              'last_name' => nil
            }
          }
        }
      end

      it 'returns contact by UUID' do
        stub_request(:get, "#{base_url}/contacts/#{contact_id}")
          .to_return(
            status: 200,
            body: expected_response.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        response = client.get(contact_id)
        expect(response).to have_attributes(
          email:,
          status: 'subscribed'
        )
      end
    end

    context 'when contact_id is an email' do
      let(:expected_response) do
        {
          'data' => {
            'id' => '019706a8-9612-77be-8586-4f26816b467a',
            'email' => email,
            'created_at' => 1_748_163_401_202,
            'updated_at' => 1_748_163_401_202,
            'list_ids' => [1, 2],
            'status' => 'subscribed',
            'fields' => {
              'first_name' => 'John',
              'last_name' => nil
            }
          }
        }
      end

      it 'returns contact by email' do
        stub_request(:get, "#{base_url}/contacts/#{CGI.escape(email)}")
          .to_return(
            status: 200,
            body: expected_response.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        response = client.get(email)
        expect(response).to have_attributes(email:)
      end

      it 'handles special characters in email' do
        special_email = 'test+special@example.com'
        stub_request(:get, "#{base_url}/contacts/#{CGI.escape(special_email)}")
          .to_return(
            status: 200,
            body: expected_response.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        response = client.get(special_email)
        expect(response).to have_attributes(email:)
      end
    end

    context 'with subscription topics' do
      let(:subscription_topics) do
        [
          { 'subscription_topic_id' => 12, 'domain_id' => 4321, 'status' => 'subscribed' },
          { 'subscription_topic_id' => 12, 'domain_id' => 4322, 'status' => 'unsubscribed' }
        ]
      end

      def stub_contact(data)
        stub_request(:get, "#{base_url}/contacts/#{contact_id}")
          .to_return(
            status: 200,
            body: { 'data' => { 'id' => contact_id, 'email' => email }.merge(data) }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns the contact preferences' do
        stub_contact('subscription_topics' => subscription_topics)

        expect(client.get(contact_id).subscription_topics).to eq(
          [
            { subscription_topic_id: 12, domain_id: 4321, status: 'subscribed' },
            { subscription_topic_id: 12, domain_id: 4322, status: 'unsubscribed' }
          ]
        )
      end

      it 'returns nil when the preferences could not be read' do
        stub_contact('subscription_topics' => nil)

        expect(client.get(contact_id).subscription_topics).to be_nil
      end

      it 'returns nil when subscription topics are not available for the account' do
        stub_contact({})

        expect(client.get(contact_id)).to have_attributes(email:, subscription_topics: nil)
      end
    end

    context 'when contact is not found' do
      it 'raises error for non-existent UUID' do
        stub_request(:get, "#{base_url}/contacts/non-existent-uuid")
          .to_return(
            status: 404,
            body: { 'error' => 'Not Found' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        expect { client.get('non-existent-uuid') }.to raise_error(Mailtrap::Error)
      end

      it 'raises error for non-existent email' do
        non_existent_email = 'nonexistent@example.com'
        stub_request(:get, "#{base_url}/contacts/#{CGI.escape(non_existent_email)}")
          .to_return(
            status: 404,
            body: { 'error' => 'Not Found' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        expect { client.get(non_existent_email) }.to raise_error(Mailtrap::Error)
      end
    end
  end

  # rubocop:disable RSpec/MultipleMemoizedHelpers
  describe '#create' do
    let(:contact_data) do
      {
        email:,
        fields: { first_name: 'John' },
        list_ids: [1, 2]
      }
    end
    let(:expected_response) do
      {
        'data' => {
          'id' => contact_id,
          'email' => email,
          'created_at' => 1_748_163_401_202,
          'updated_at' => 1_748_163_401_202,
          'list_ids' => [1, 2],
          'status' => 'subscribed',
          'fields' => {
            'first_name' => 'John',
            'last_name' => nil
          }
        }
      }
    end

    it 'creates a new contact' do
      stub_request(:post, "#{base_url}/contacts")
        .with(
          body: { contact: contact_data }.to_json
        )
        .to_return(
          status: 201,
          body: expected_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = client.create(contact_data)
      expect(response).to have_attributes(email:)
      expect(response.newly_created?).to be true
    end

    it 'raises error for invalid contact data' do
      invalid_data = { email: 'invalid-email' }
      stub_request(:post, "#{base_url}/contacts")
        .with(
          body: { contact: invalid_data }.to_json
        )
        .to_return(
          status: 422,
          body: { 'errors' => { 'email' => ['is invalid'] } }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { client.create(invalid_data) }.to raise_error(Mailtrap::Error)
    end

    context 'with subscription topics' do
      let(:subscription_topics) { [{ subscription_topic_id: 12, domain_id: 4321, status: 'unsubscribed' }] }
      let(:contact_data) { { email:, subscription_topics: } }

      it 'sends them and returns the contact preferences' do
        stub = stub_request(:post, "#{base_url}/contacts")
               .with(body: { contact: contact_data }.to_json)
               .to_return(
                 status: 201,
                 body: { 'data' => expected_response['data'].merge('subscription_topics' => subscription_topics) }
                   .to_json,
                 headers: { 'Content-Type' => 'application/json' }
               )

        response = client.create(contact_data)
        expect(stub).to have_been_requested
        expect(response.subscription_topics).to eq(subscription_topics)
      end

      it 'raises error when the account has no subscription topics' do
        stub_request(:post, "#{base_url}/contacts")
          .to_return(
            status: 422,
            body: { 'errors' => { 'subscription_topics' => ['are not available for this account'] } }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        expect { client.create(contact_data) }.to raise_error(Mailtrap::Error, /are not available for this account/)
      end

      it 'raises error naming the contact when the preferences were not saved' do
        message = 'The contact was saved, but its subscription topic preferences were not. ' \
                  "Send them again in an update of contact #{contact_id}."
        stub_request(:post, "#{base_url}/contacts")
          .to_return(
            status: 503,
            body: { 'errors' => message }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        expect { client.create(contact_data) }.to raise_error(Mailtrap::Error, message)
      end
    end
  end

  describe '#update' do
    let(:update_data) do
      {
        email:,
        fields: { last_name: 'Smith' },
        unsubscribed: true
      }
    end
    let(:expected_response) do
      {
        'data' => {
          'id' => contact_id,
          'email' => email,
          'created_at' => 1_748_163_401_202,
          'updated_at' => 1_748_163_401_202,
          'list_ids' => [3],
          'status' => 'unsubscribed',
          'fields' => {
            'first_name' => 'John',
            'last_name' => 'Smith'
          }
        },
        'action' => 'updated'
      }
    end

    it 'contact by id' do
      stub_request(:patch, "#{base_url}/contacts/#{contact_id}")
        .with(
          body: { contact: update_data }.to_json
        )
        .to_return(
          status: 200,
          body: expected_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
      response = client.upsert(contact_id, update_data)

      expect(response).to have_attributes(
        id: contact_id,
        fields: include(
          last_name: 'Smith'
        )
      )
      expect(response.newly_created?).to be false
    end

    it 'contact by email' do
      stub_request(:patch, "#{base_url}/contacts/#{CGI.escape(email)}")
        .with(
          body: { contact: update_data }.to_json
        )
        .to_return(
          status: 200,
          body: expected_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = client.upsert(email, update_data)
      expect(response).to have_attributes(email:)
      expect(response.newly_created?).to be false
    end

    it 'changes only the subscription topic preferences' do
      subscription_topics = [{ subscription_topic_id: 12, domain_id: 4321, status: 'subscribed' }]
      stub = stub_request(:patch, "#{base_url}/contacts/#{contact_id}")
             .with(body: { contact: { subscription_topics: } }.to_json)
             .to_return(
               status: 200,
               body: expected_response.merge(
                 'data' => expected_response['data'].merge('subscription_topics' => subscription_topics)
               ).to_json,
               headers: { 'Content-Type' => 'application/json' }
             )

      response = client.upsert(contact_id, subscription_topics:)
      expect(stub).to have_been_requested
      expect(response.subscription_topics).to eq(subscription_topics)
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers

  describe '#delete' do
    it 'deletes contact by id' do
      stub_request(:delete, "#{base_url}/contacts/#{contact_id}")
        .to_return(status: 204)

      response = client.delete(contact_id)
      expect(response).to be_nil
    end

    it 'deletes contact by email' do
      stub_request(:delete, "#{base_url}/contacts/#{CGI.escape(email)}")
        .to_return(status: 204)

      response = client.delete(email)
      expect(response).to be_nil
    end
  end

  describe '#add_to_lists' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:list_ids) { [1, 2, 3] }
    let(:expected_response) do
      {
        'data' => {
          'id' => contact_id,
          'email' => email,
          'created_at' => 1_748_163_401_202,
          'updated_at' => 1_748_163_401_202,
          'list_ids' => [1, 2, 3, 4, 5],
          'status' => 'subscribed',
          'fields' => {
            'first_name' => 'John',
            'last_name' => 'Smith'
          }
        },
        'action' => 'updated'
      }
    end

    it 'adds contact to lists by id' do
      stub_request(:patch, "#{base_url}/contacts/#{contact_id}")
        .with(
          body: { contact: { list_ids_included: list_ids } }.to_json
        )
        .to_return(
          status: 200,
          body: expected_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = client.add_to_lists(contact_id, list_ids)
      expect(response).to have_attributes(
        id: contact_id,
        list_ids: include(1, 2, 3, 4, 5)
      )
    end

    it 'adds contact to lists by email' do
      stub_request(:patch, "#{base_url}/contacts/#{CGI.escape(email)}")
        .with(
          body: { contact: { list_ids_included: list_ids } }.to_json
        )
        .to_return(
          status: 200,
          body: expected_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = client.add_to_lists(email, list_ids)
      expect(response).to have_attributes(email:)
    end

    it 'handles empty list_ids array' do
      stub_request(:patch, "#{base_url}/contacts/#{contact_id}")
        .with(
          body: { contact: { list_ids_included: [] } }.to_json
        )
        .to_return(
          status: 200,
          body: expected_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = client.add_to_lists(contact_id, [])
      expect(response).to have_attributes(
        id: contact_id
      )
    end

    it 'uses default empty array when no list_ids provided' do
      stub_request(:patch, "#{base_url}/contacts/#{contact_id}")
        .with(
          body: { contact: { list_ids_included: [] } }.to_json
        )
        .to_return(
          status: 200,
          body: expected_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = client.add_to_lists(contact_id)
      expect(response).to have_attributes(
        id: contact_id
      )
    end
  end

  describe '#remove_from_lists' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:list_ids) { [1, 2] }
    let(:expected_response) do
      {
        'data' => {
          'id' => contact_id,
          'email' => email,
          'created_at' => 1_748_163_401_202,
          'updated_at' => 1_748_163_401_202,
          'list_ids' => [3, 4, 5],
          'status' => 'subscribed',
          'fields' => {
            'first_name' => 'John',
            'last_name' => 'Smith'
          }
        },
        'action' => 'updated'
      }
    end

    it 'removes contact from lists by id' do
      stub_request(:patch, "#{base_url}/contacts/#{contact_id}")
        .with(
          body: { contact: { list_ids_excluded: list_ids } }.to_json
        )
        .to_return(
          status: 200,
          body: expected_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = client.remove_from_lists(contact_id, list_ids)
      expect(response).to have_attributes(
        id: contact_id,
        list_ids: include(3, 4, 5)
      )
    end

    it 'removes contact from lists by email' do
      stub_request(:patch, "#{base_url}/contacts/#{CGI.escape(email)}")
        .with(
          body: { contact: { list_ids_excluded: list_ids } }.to_json
        )
        .to_return(
          status: 200,
          body: expected_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = client.remove_from_lists(email, list_ids)
      expect(response).to have_attributes(
        email:
      )
    end

    it 'handles empty list_ids array' do
      stub_request(:patch, "#{base_url}/contacts/#{contact_id}")
        .with(
          body: { contact: { list_ids_excluded: [] } }.to_json
        )
        .to_return(
          status: 200,
          body: expected_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = client.remove_from_lists(contact_id, [])
      expect(response).to have_attributes(
        id: contact_id
      )
    end

    it 'uses default empty array when no list_ids provided' do
      stub_request(:patch, "#{base_url}/contacts/#{contact_id}")
        .with(
          body: { contact: { list_ids_excluded: [] } }.to_json
        )
        .to_return(
          status: 200,
          body: expected_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = client.remove_from_lists(contact_id)
      expect(response).to have_attributes(
        id: contact_id
      )
    end

    it 'handles special characters in email' do
      special_email = 'test+special@example.com'
      stub_request(:patch, "#{base_url}/contacts/#{CGI.escape(special_email)}")
        .with(
          body: { contact: { list_ids_excluded: list_ids } }.to_json
        )
        .to_return(
          status: 200,
          body: expected_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = client.remove_from_lists(special_email, list_ids)
      expect(response).to have_attributes(
        email:
      )
    end
  end
end
