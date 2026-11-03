# frozen_string_literal: true

RSpec.describe Mailtrap::InboxesAPI do
  let(:client) { Mailtrap::Client.new(api_key: 'local-api-key') }

  it 'works as SandboxesAPI and warns that it is deprecated',
     vcr: { cassette_name: 'Mailtrap_SandboxesAPI/_list/maps_response_data_to_Sandbox_objects' } do
    inboxes_api = nil

    expect { inboxes_api = described_class.new(1_111_111, client) }
      .to output(/inboxes_api_spec.rb:\d+: .*Mailtrap::InboxesAPI is deprecated .*; use Mailtrap::SandboxesAPI/).to_stderr
    expect(inboxes_api).to be_a(Mailtrap::SandboxesAPI)
    expect(inboxes_api.list).to all(be_a(Mailtrap::Sandbox))
  end
end
