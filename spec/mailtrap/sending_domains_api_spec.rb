# frozen_string_literal: true

RSpec.describe Mailtrap::SendingDomainsAPI do
  let(:client) { Mailtrap::Client.new(api_key: 'local-api-key') }

  it 'works as DomainsAPI and warns that it is deprecated',
     vcr: { cassette_name: 'Mailtrap_DomainsAPI/_list/maps_response_data_to_Domain_objects' } do
    sending_domains_api = nil

    expect { sending_domains_api = described_class.new(1_111_111, client) }
      .to output(/sending_domains_api_spec.rb:\d+: .*Mailtrap::SendingDomainsAPI is deprecated .*; use Mailtrap::DomainsAPI/)
      .to_stderr
    expect(sending_domains_api).to be_a(Mailtrap::DomainsAPI)
    expect(sending_domains_api.list).to all(be_a(Mailtrap::Domain))
  end

  it 'updates a domain with the options it inherits',
     vcr: { cassette_name: 'Mailtrap_DomainsAPI/_update/maps_response_data_to_Domain_object' } do
    domain = nil
    request = {
      open_tracking_enabled: true,
      click_tracking_enabled: true,
      tracking_opt_out_enabled: true,
      auto_unsubscribe_link_enabled: false,
      inbound_enabled: false
    }

    expect { domain = described_class.new(1_111_111, client).update(61_802, **request) }.to output.to_stderr
    expect(domain).to be_a(Mailtrap::Domain).and have_attributes(id: 61_802, open_tracking_enabled: true)
  end
end
