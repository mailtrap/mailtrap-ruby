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

  it 'creates a sandbox with the options it inherits',
     vcr: { cassette_name: 'Mailtrap_SandboxesAPI/_create/maps_response_data_to_Sandbox_object' } do
    sandbox = nil

    expect { sandbox = described_class.new(1_111_111, client).create(name: 'Test Inbox', project_id: 2_379_735) }
      .to output.to_stderr
    expect(sandbox).to be_a(Mailtrap::Sandbox).and have_attributes(name: 'Test Inbox')
  end

  it 'updates a sandbox with the options it inherits',
     vcr: { cassette_name: 'Mailtrap_SandboxesAPI/_update/maps_response_data_to_Sandbox_object' } do
    sandbox = nil

    expect do
      sandbox = described_class.new(1_111_111, client)
                               .update(4_278_175, name: 'Updated Inbox', email_username: 'updated_username')
    end.to output.to_stderr
    expect(sandbox).to be_a(Mailtrap::Sandbox).and have_attributes(name: 'Updated Inbox')
  end
end
