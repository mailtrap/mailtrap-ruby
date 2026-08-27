# frozen_string_literal: true

RSpec.describe Mailtrap::TrackingOptOutsAPI, :vcr do
  subject(:tracking_opt_outs) { described_class.new(client) }

  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }
  let(:domain_id) { 12_345 }
  let(:tracking_opt_out_id) { '4c3c5ece-436e-4596-af69-647f99059380' }

  describe '#list' do
    subject(:list) { tracking_opt_outs.list }

    it 'maps response data to TrackingOptOut objects' do
      expect(list).to be_a(Mailtrap::TrackingOptOutsListResponse)
      expect(list.data).to all(be_a(Mailtrap::TrackingOptOut))
      expect(list.data.first).to have_attributes(
        id: be_a(String),
        email: be_a(String),
        created_at: be_a(String),
        domain_name: be_a(String)
      )
    end

    context 'with filters' do
      subject(:list) do
        tracking_opt_outs.list(
          email: 'tracked@example.com',
          start_time: '2026-08-01T00:00:00Z',
          end_time: '2026-08-31T23:59:59Z'
        )
      end

      it 'returns the matching tracking opt-outs' do
        expect(list.data).to all(be_a(Mailtrap::TrackingOptOut))
      end
    end

    context 'when api key is incorrect' do
      let(:client) { Mailtrap::Client.new(api_key: 'incorrect-api-key') }

      it 'raises authorization error' do
        expect { list }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::AuthorizationError)
          expect(error.message).to include('Incorrect API token')
        end
      end
    end
  end

  describe '#create' do
    subject(:create) { tracking_opt_outs.create(request) }

    let(:request) { { email: 'tracked@example.com', domain_id: } }

    it 'maps response data to TrackingOptOut object' do
      expect(create).to be_a(Mailtrap::TrackingOptOut)
      expect(create).to have_attributes(
        id: be_a(String),
        email: be_a(String),
        created_at: be_a(String),
        domain_name: be_a(String)
      )
    end

    context 'when invalid options are provided' do
      let(:request) { super().merge(unknown_option: true) }

      it 'raises ArgumentError' do
        expect { create }.to raise_error(ArgumentError, /invalid options are given/)
      end
    end

    context 'when email is invalid' do
      let(:request) { { email: 'not-an-email', domain_id: } }

      it 'raises a Mailtrap::Error' do
        expect { create }.to raise_error(Mailtrap::Error)
      end
    end
  end

  describe '#delete' do
    subject(:delete) { tracking_opt_outs.delete(tracking_opt_out_id) }

    it 'returns the deleted tracking opt-out' do
      expect(delete).to be_a(Mailtrap::TrackingOptOut)
      expect(delete).to have_attributes(
        id: be_a(String),
        email: be_a(String)
      )
    end

    context 'when tracking opt-out does not exist' do
      let(:tracking_opt_out_id) { 'missing' }

      it 'raises a Mailtrap::Error' do
        expect { delete }.to raise_error(Mailtrap::Error)
      end
    end
  end
end
