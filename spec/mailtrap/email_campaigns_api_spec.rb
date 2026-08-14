# frozen_string_literal: true

RSpec.describe Mailtrap::EmailCampaignsAPI do
  subject(:email_campaigns_api) { described_class.new(Mailtrap::Client.new(api_key: 'correct-api-key')) }

  let(:base_url) { 'https://mailtrap.io/api/email_campaigns' }
  let(:campaign_attributes) do
    {
      'id' => 4567,
      'domain_id' => 4321,
      'domain_name' => 'acme.com',
      'name' => 'Spring Sale',
      'from_local_part' => 'news',
      'from_display_name' => 'Acme Marketing',
      'current_state' => 'draft',
      'current_state_metadata' => {},
      'contact_list_ids' => [55, 56],
      'contact_segment_ids' => [12],
      'delivery_mode' => 'rapid',
      'delivery_options' => { 'emails_per_hour' => nil },
      'recipient_total_count' => nil,
      'template' => {
        'id' => 789,
        'subject' => 'Spring is here — 30% off',
        'merge_tags' => ['first_name'],
        'body_html' => nil,
        'body_text' => nil
      }
    }
  end

  describe '#list' do
    it 'returns a paginated list of EmailCampaign objects' do
      stub_request(:get, base_url)
        .to_return(
          status: 200,
          body: {
            'data' => [campaign_attributes],
            'pagination' => { 'token' => 1, 'prev_token' => nil, 'next_token' => nil }
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = email_campaigns_api.list
      expect(response).to be_a(Mailtrap::EmailCampaignsListResponse)
      expect(response.data).to all(be_a(Mailtrap::EmailCampaign))
      expect(response.data.first).to have_attributes(
        id: 4567,
        name: 'Spring Sale',
        domain_id: 4321,
        contact_list_ids: [55, 56],
        contact_segment_ids: [12],
        delivery_mode: 'rapid'
      )
      expect(response.pagination).to eq(token: 1, prev_token: nil, next_token: nil)
    end

    it 'filters campaigns by name and passes pagination params' do
      stub = stub_request(:get, base_url)
             .with(query: { search: 'Spring', per_page: '10', token: '2' })
             .to_return(
               status: 200,
               body: { 'data' => [], 'pagination' => { 'token' => 2 } }.to_json,
               headers: { 'Content-Type' => 'application/json' }
             )

      response = email_campaigns_api.list(per_page: 10, search: 'Spring', token: 2)
      expect(stub).to have_been_requested
      expect(response.data).to eq([])
    end

    it 'raises error when api key is incorrect' do
      stub_request(:get, base_url)
        .to_return(
          status: 401,
          body: { 'error' => 'Incorrect API token' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { email_campaigns_api.list }.to raise_error(Mailtrap::AuthorizationError, /Incorrect API token/)
    end
  end

  describe '#get' do
    it 'returns an EmailCampaign object' do
      stub_request(:get, "#{base_url}/4567")
        .to_return(
          status: 200,
          body: { 'data' => campaign_attributes }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = email_campaigns_api.get(4567)
      expect(response).to be_a(Mailtrap::EmailCampaign)
      expect(response).to have_attributes(id: 4567, name: 'Spring Sale', current_state: 'draft')
    end

    it 'raises error when the campaign does not exist' do
      stub_request(:get, "#{base_url}/999")
        .to_return(
          status: 404,
          body: { 'error' => 'Not Found' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { email_campaigns_api.get(999) }.to raise_error(Mailtrap::Error, /Not Found/)
    end
  end

  describe '#create' do
    let(:request) do
      {
        name: 'Spring Sale',
        domain_id: 4321,
        from_display_name: 'Acme Marketing',
        from_local_part: 'news',
        reply_to: { display_name: 'Acme Support', local_part: 'support', domain: 'acme.com' },
        template_attributes: { subject: 'Spring is here — 30% off' },
        delivery_mode: 'gradual',
        delivery_options: { emails_per_hour: 1000 },
        contact_list_ids: [55, 56],
        contact_segment_ids: [12]
      }
    end

    it 'sends a flat request body and returns the created EmailCampaign' do
      stub = stub_request(:post, base_url)
             .with(body: request.to_json)
             .to_return(
               status: 201,
               body: { 'data' => campaign_attributes }.to_json,
               headers: { 'Content-Type' => 'application/json' }
             )

      response = email_campaigns_api.create(request)
      expect(stub).to have_been_requested
      expect(response).to be_a(Mailtrap::EmailCampaign)
      expect(response).to have_attributes(id: 4567, name: 'Spring Sale', current_state: 'draft')
    end

    it 'raises ArgumentError when invalid options are provided' do
      expect { email_campaigns_api.create(name: 'Spring Sale', unknown_option: true) }
        .to raise_error(ArgumentError, /invalid options are given/)
    end

    it 'raises error when validation fails' do
      stub_request(:post, base_url)
        .to_return(
          status: 422,
          body: { 'errors' => { 'domain_id' => ['must exist'] } }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { email_campaigns_api.create(name: 'Spring Sale') }.to raise_error(Mailtrap::Error)
    end
  end

  describe '#update' do
    let(:request) do
      {
        name: 'Spring Sale (updated)',
        template_attributes: { subject: 'New subject', body_html: '<html><body>Hi!</body></html>' }
      }
    end

    it 'sends a flat PATCH request body and returns the updated EmailCampaign' do
      stub = stub_request(:patch, "#{base_url}/4567")
             .with(body: request.to_json)
             .to_return(
               status: 200,
               body: { 'data' => campaign_attributes.merge('name' => 'Spring Sale (updated)') }.to_json,
               headers: { 'Content-Type' => 'application/json' }
             )

      response = email_campaigns_api.update(4567, request)
      expect(stub).to have_been_requested
      expect(response).to have_attributes(id: 4567, name: 'Spring Sale (updated)')
    end

    it 'raises ArgumentError when invalid options are provided' do
      expect { email_campaigns_api.update(4567, unknown_option: true) }
        .to raise_error(ArgumentError, /invalid options are given/)
    end

    it 'raises error when the campaign is not a draft' do
      stub_request(:patch, "#{base_url}/4567")
        .to_return(
          status: 422,
          body: { 'errors' => 'Only draft campaigns can be updated' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { email_campaigns_api.update(4567, name: 'New name') }.to raise_error(Mailtrap::Error)
    end
  end

  describe '#delete' do
    it 'deletes the campaign and returns nil' do
      stub_request(:delete, "#{base_url}/4567").to_return(status: 204)

      expect(email_campaigns_api.delete(4567)).to be_nil
    end

    it 'raises error when the campaign does not exist' do
      stub_request(:delete, "#{base_url}/999")
        .to_return(
          status: 404,
          body: { 'error' => 'Not Found' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { email_campaigns_api.delete(999) }.to raise_error(Mailtrap::Error, /Not Found/)
    end
  end

  describe '#start' do
    it 'starts the campaign' do
      stub = stub_request(:post, "#{base_url}/4567/start")
             .to_return(
               status: 200,
               body: { 'data' => campaign_attributes.merge('current_state' => 'started') }.to_json,
               headers: { 'Content-Type' => 'application/json' }
             )

      response = email_campaigns_api.start(4567)
      expect(stub).to have_been_requested
      expect(response).to have_attributes(id: 4567, current_state: 'started')
    end

    it 'raises error when the campaign is not a draft' do
      stub_request(:post, "#{base_url}/4567/start")
        .to_return(
          status: 422,
          body: { 'errors' => "Cannot transition from 'started' to 'started'" }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { email_campaigns_api.start(4567) }.to raise_error(Mailtrap::Error, /Cannot transition/)
    end
  end

  describe '#schedule' do
    it 'sends the datetime and returns the scheduled campaign' do
      stub = stub_request(:post, "#{base_url}/4567/schedule")
             .with(body: { datetime: '2026-06-01T09:00:00.000Z' }.to_json)
             .to_return(
               status: 200,
               body: {
                 'data' => campaign_attributes.merge(
                   'current_state' => 'scheduled',
                   'current_state_metadata' => { 'scheduled_at' => '2026-06-01T09:00:00.000Z' }
                 )
               }.to_json,
               headers: { 'Content-Type' => 'application/json' }
             )

      response = email_campaigns_api.schedule(4567, '2026-06-01T09:00:00.000Z')
      expect(stub).to have_been_requested
      expect(response).to have_attributes(
        current_state: 'scheduled',
        current_state_metadata: { scheduled_at: '2026-06-01T09:00:00.000Z' }
      )
    end

    it 'raises error when sending validation fails' do
      stub_request(:post, "#{base_url}/4567/schedule")
        .with(body: { datetime: '2026-06-01T09:00:00.000Z' }.to_json)
        .to_return(
          status: 422,
          body: { 'errors' => ["Campaign design can't be blank"] }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { email_campaigns_api.schedule(4567, '2026-06-01T09:00:00.000Z') }
        .to raise_error(Mailtrap::Error, /design can't be blank/)
    end
  end

  describe '#cancel' do
    it 'cancels the scheduled campaign' do
      stub_request(:post, "#{base_url}/4567/cancel")
        .to_return(
          status: 200,
          body: { 'data' => campaign_attributes }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect(email_campaigns_api.cancel(4567)).to have_attributes(id: 4567, current_state: 'draft')
    end

    it 'raises error when the campaign is not scheduled' do
      stub_request(:post, "#{base_url}/4567/cancel")
        .to_return(
          status: 422,
          body: { 'errors' => 'Campaign is not scheduled' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { email_campaigns_api.cancel(4567) }.to raise_error(Mailtrap::Error, /not scheduled/)
    end
  end

  describe '#terminate' do
    it 'terminates the sending campaign' do
      stub_request(:post, "#{base_url}/4567/terminate")
        .to_return(
          status: 200,
          body: { 'data' => campaign_attributes.merge('current_state' => 'terminating') }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect(email_campaigns_api.terminate(4567)).to have_attributes(current_state: 'terminating')
    end
  end

  describe '#reset' do
    it 'resets the scheduled campaign back to draft' do
      stub_request(:post, "#{base_url}/4567/reset")
        .to_return(
          status: 200,
          body: { 'data' => campaign_attributes }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect(email_campaigns_api.reset(4567)).to have_attributes(current_state: 'draft')
    end
  end

  describe '#stats' do
    let(:stats_attributes) do
      {
        'delivery_count' => 1450,
        'open_count' => 820,
        'click_count' => 310,
        'bounce_count' => 30,
        'unsubscription_count' => 12,
        'sent_count' => 1500,
        'spam_count' => 5,
        'delivery_rate' => 0.9667,
        'open_rate' => 0.5655,
        'click_rate' => 0.2138,
        'bounce_rate' => 0.02,
        'spam_rate' => 0.0033,
        'unsubscription_rate' => 0.0083
      }
    end

    it 'returns an EmailCampaignStats object' do
      stub_request(:get, "#{base_url}/4567/stats")
        .to_return(
          status: 200,
          body: { 'data' => stats_attributes }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      response = email_campaigns_api.stats(4567)
      expect(response).to be_a(Mailtrap::EmailCampaignStats)
      expect(response).to have_attributes(delivery_count: 1450, delivery_rate: 0.9667)
    end

    it 'passes the aggregation window params' do
      stub = stub_request(:get, "#{base_url}/4567/stats")
             .with(query: { start_date: '2026-05-01', end_date: '2026-05-31' })
             .to_return(
               status: 200,
               body: { 'data' => stats_attributes }.to_json,
               headers: { 'Content-Type' => 'application/json' }
             )

      response = email_campaigns_api.stats(4567, start_date: '2026-05-01', end_date: '2026-05-31')
      expect(stub).to have_been_requested
      expect(response).to have_attributes(sent_count: 1500)
    end

    it 'raises error when the campaign does not exist' do
      stub_request(:get, "#{base_url}/999/stats")
        .to_return(
          status: 404,
          body: { 'error' => 'Not Found' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect { email_campaigns_api.stats(999) }.to raise_error(Mailtrap::Error, /Not Found/)
    end
  end

  # Recorded coverage complementing the stubbed examples above. Lifecycle actions
  # (start/schedule/cancel/terminate/reset) stay stubbed: recording them would mean
  # driving a real campaign through sending states, and `start` mails a live audience.
  describe 'vcr#list', :vcr do
    subject(:list) { email_campaigns_api.list(search: 'Spring Sale') }

    it 'maps response data to EmailCampaign objects' do
      expect(list).to be_a(Mailtrap::EmailCampaignsListResponse)
      expect(list.data).to all(be_a(Mailtrap::EmailCampaign))
      expect(list.data.first).to have_attributes(
        id: be_a(Integer),
        name: be_a(String),
        domain_id: be_a(Integer),
        current_state: be_a(String)
      )
      expect(list.pagination).to include(:token)
    end
  end

  describe 'vcr#get', :vcr do
    subject(:get) { email_campaigns_api.get(37_947) }

    it 'maps response data to an EmailCampaign object' do
      expect(get).to be_a(Mailtrap::EmailCampaign)
      expect(get).to have_attributes(
        id: 37_947,
        name: be_a(String),
        domain_id: be_a(Integer),
        current_state: be_a(String)
      )
    end
  end

  describe 'vcr#create', :vcr do
    subject(:create) do
      email_campaigns_api.create(
        name: 'Spring Sale',
        domain_id: 1_132_895,
        from_local_part: 'news',
        template_attributes: { subject: 'Spring is here — 30% off' }
      )
    end

    it 'maps response data to the created EmailCampaign' do
      expect(create).to be_a(Mailtrap::EmailCampaign)
      expect(create).to have_attributes(
        id: be_a(Integer),
        name: 'Spring Sale',
        current_state: 'draft'
      )
    end
  end

  describe 'vcr#update', :vcr do
    subject(:update) { email_campaigns_api.update(37_947, name: 'Spring Sale (updated)') }

    it 'maps response data to the updated EmailCampaign' do
      expect(update).to be_a(Mailtrap::EmailCampaign)
      expect(update).to have_attributes(id: 37_947, name: 'Spring Sale (updated)')
    end
  end

  describe 'vcr#stats', :vcr do
    subject(:stats) { email_campaigns_api.stats(37_947) }

    it 'maps response data to an EmailCampaignStats object' do
      expect(stats).to be_a(Mailtrap::EmailCampaignStats)
      expect(stats).to have_attributes(
        delivery_count: be_a(Integer),
        open_count: be_a(Integer),
        delivery_rate: be_a(Numeric),
        open_rate: be_a(Numeric)
      )
    end
  end
end
