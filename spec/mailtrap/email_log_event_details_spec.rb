# frozen_string_literal: true

RSpec.describe Mailtrap::EmailLogEventDetails do
  describe '.build' do
    it 'returns Delivery struct for delivery event_type' do
      details = described_class.build(
        'delivery',
        {
          sending_ip: '192.0.2.1',
          recipient_mx: 'mx.example.com',
          email_service_provider: 'Example Provider'
        }
      )
      expect(details).to be_a(described_class::Delivery)
      expect(details).to have_attributes(
        sending_ip: '192.0.2.1',
        recipient_mx: 'mx.example.com',
        email_service_provider: 'Example Provider'
      )
    end

    it 'returns Click struct for click event_type' do
      details = described_class.build(
        'click',
        {
          click_url: 'https://example.com/link',
          web_ip_address: '198.51.100.50'
        }
      )
      expect(details).to be_a(described_class::Click)
      expect(details).to have_attributes(
        click_url: 'https://example.com/link',
        web_ip_address: '198.51.100.50'
      )
    end

    it 'returns Bounce struct for bounce event_type' do
      details = described_class.build(
        'bounce', {
          bounce_category: 'invalid_recipient',
          email_service_provider_response: 'User unknown'
        }
      )
      expect(details).to be_a(described_class::Bounce)
      expect(details).to have_attributes(
        bounce_category: 'invalid_recipient',
        email_service_provider_response: 'User unknown'
      )
    end

    %w[topic_unsubscribe topic_resubscribe].each do |event_type|
      it "returns TopicSubscription struct for #{event_type} event_type" do
        details = described_class.build(event_type, { web_ip_address: '198.51.100.50', subscription_topic_id: 12 })
        expect(details).to be_a(described_class::TopicSubscription)
        expect(details).to have_attributes(web_ip_address: '198.51.100.50', subscription_topic_id: 12)
      end
    end

    it 'returns the details hash for an unknown event_type' do
      details = { web_ip_address: '198.51.100.50', new_detail: 'value' }

      expect(described_class.build('unknown_type', details)).to eq(details)
    end

    it 'returns the details for a nil event_type' do
      expect(described_class.build(nil, nil)).to be_nil
    end
  end
end
