# frozen_string_literal: true

RSpec.describe Mailtrap::EmailCampaign do
  describe '#initialize' do
    subject(:email_campaign) { described_class.new(attributes) }

    let(:attributes) do
      {
        id: 4567,
        type: 'EmailCampaign',
        mailsend_domain_id: 123,
        mailsend_domain_name: 'acme.com',
        name: 'Spring Sale',
        from_local_part: 'news',
        from_display_name: 'Acme Marketing',
        reply_to: { display_name: 'Acme Support', local_part: 'support', domain: 'acme.com' },
        current_state: 'draft',
        current_state_metadata: {},
        created_at: '2026-05-01T10:15:00.000Z',
        updated_at: '2026-05-02T09:00:00.000Z',
        last_started_at: nil,
        last_started_at_date: nil,
        recipient_total_count: 1500,
        delivery_mode: 'immediate',
        delivery_options: { emails_per_hour: 1000 },
        scheduled_for: nil,
        audience_defined: true,
        stats: Mailtrap::EmailCampaignStats.new(delivery_count: 1450),
        template: { id: 789, subject: 'Spring is here — 30% off' }
      }
    end

    it 'creates an email campaign with all attributes' do
      expect(email_campaign).to have_attributes(
        id: 4567,
        type: 'EmailCampaign',
        mailsend_domain_id: 123,
        mailsend_domain_name: 'acme.com',
        name: 'Spring Sale',
        from_local_part: 'news',
        from_display_name: 'Acme Marketing',
        reply_to: { display_name: 'Acme Support', local_part: 'support', domain: 'acme.com' },
        current_state: 'draft',
        current_state_metadata: {},
        created_at: '2026-05-01T10:15:00.000Z',
        updated_at: '2026-05-02T09:00:00.000Z',
        last_started_at: nil,
        last_started_at_date: nil,
        recipient_total_count: 1500,
        delivery_mode: 'immediate',
        delivery_options: { emails_per_hour: 1000 },
        scheduled_for: nil,
        audience_defined: true,
        stats: Mailtrap::EmailCampaignStats.new(delivery_count: 1450),
        template: { id: 789, subject: 'Spring is here — 30% off' }
      )
    end

    context 'when optional fields are omitted (e.g. a list item)' do
      let(:attributes) do
        {
          id: 4567,
          type: 'EmailCampaign',
          name: 'Spring Sale',
          current_state: 'draft'
        }
      end

      it 'leaves omitted members as nil' do
        expect(email_campaign).to have_attributes(
          id: 4567,
          name: 'Spring Sale',
          current_state: 'draft',
          audience_defined: nil,
          stats: nil,
          scheduled_for: nil
        )
      end
    end
  end

  describe Mailtrap::EmailCampaignStats do
    subject(:stats) { described_class.new(attributes) }

    let(:attributes) do
      {
        delivery_count: 1450,
        open_count: 820,
        click_count: 310,
        bounce_count: 30,
        unsubscription_count: 12,
        sent_count: 1500,
        spam_count: 5,
        message_count: 1500,
        reject_count: 20,
        delivery_rate: 0.9667,
        open_rate: 0.5655,
        click_rate: 0.2138,
        bounce_rate: 0.02,
        spam_rate: 0.0033,
        unsubscription_rate: 0.0083
      }
    end

    it 'creates stats with all attributes' do
      expect(stats).to have_attributes(
        delivery_count: 1450,
        open_count: 820,
        click_count: 310,
        bounce_count: 30,
        unsubscription_count: 12,
        sent_count: 1500,
        spam_count: 5,
        message_count: 1500,
        reject_count: 20,
        delivery_rate: 0.9667,
        open_rate: 0.5655,
        click_rate: 0.2138,
        bounce_rate: 0.02,
        spam_rate: 0.0033,
        unsubscription_rate: 0.0083
      )
    end
  end

  describe Mailtrap::EmailCampaignsListResponse do
    subject(:list_response) { described_class.new(attributes) }

    let(:attributes) do
      {
        data: [Mailtrap::EmailCampaign.new(id: 4567, name: 'Spring Sale')],
        pagination: { token: 1, prev_token: nil, next_token: 2 }
      }
    end

    it 'creates a list response with data and pagination' do
      expect(list_response).to have_attributes(
        data: [Mailtrap::EmailCampaign.new(id: 4567, name: 'Spring Sale')],
        pagination: { token: 1, prev_token: nil, next_token: 2 }
      )
    end
  end
end
