# frozen_string_literal: true

RSpec.describe Mailtrap::AccountAccessesAPI, :vcr do
  subject(:project_api) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 2326475) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', '5a5a89884129f29321e9014821496340')) }

  describe '#list' do
    subject(:list) { project_api.list }

    it 'maps response data to AccountAccess objects' do
      pp list
      expect(list).to all(be_a(Mailtrap::AccountAccess))
    end

    context 'when api key is incorrect' do
      let(:client) { Mailtrap::Client.new(api_key: 'incorrect-api-key') }

      it 'raises authorization error' do
        expect { list }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::AuthorizationError)
          expect(error.message).to include('Incorrect API token')
          expect(error.messages.any? { |msg| msg.include?('Incorrect API token') }).to be true
        end
      end
    end
  end

  describe '#delete' do
    subject(:delete) { project_api.delete(project_id) }

    let!(:created_project) do
      project_api.create(
        name: 'Project to Delete'
      )
    end
    let(:project_id) { created_project.id }

    it 'returns deleted project id' do
      expect(delete).to eq({ id: project_id })
    end

    context 'when project does not exist' do
      let(:project_id) { 999_999 }

      it 'raises not found error' do
        expect { delete }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end
end
