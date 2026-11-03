# frozen_string_literal: true

RSpec.describe Mailtrap::SendingDomainsAPI do
  let(:client) { Mailtrap::Client.new(api_key: 'local-api-key') }

  it 'works as DomainsAPI and warns that it is deprecated',
     vcr: { cassette_name: 'Mailtrap_DomainsAPI/_list/maps_response_data_to_Domain_objects' } do
    sending_domains_api = nil

    expect { sending_domains_api = described_class.new(1_111_111, client) }
      .to output(/Mailtrap::SendingDomainsAPI is deprecated .*; use Mailtrap::DomainsAPI instead/).to_stderr
    expect(sending_domains_api).to be_a(Mailtrap::DomainsAPI)
    expect(sending_domains_api.list).to all(be_a(Mailtrap::Domain))
  end
end
