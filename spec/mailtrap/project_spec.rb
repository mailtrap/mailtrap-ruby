# frozen_string_literal: true

RSpec.describe Mailtrap::Project do
  describe '#initialize' do
    subject(:project) { described_class.new(attributes) }

    let(:attributes) do
      {
        id: '123456',
        name: 'My Project',
        share_links: [
          {
            id: 'abc123',
            name: 'Share Link 1',
            url: 'https://example.com/share/1'
          }
        ],
        inboxes: [
          {
            id: 456,
            name: 'Test Inbox',
            username: 'test@inbox.mailtrap.io'
          }
        ],
        permissions: {
          can_read: true,
          can_update: true,
          can_destroy: false,
          can_leave: true
        }
      }
    end

    it 'creates a project with all attributes' do
      expect(project).to match_struct(
        id: '123456',
        name: 'My Project',
        share_links: [
          {
            id: 'abc123',
            name: 'Share Link 1',
            url: 'https://example.com/share/1'
          }
        ],
        permissions: {
          can_read: true,
          can_update: true,
          can_destroy: false,
          can_leave: true
        },
        inboxes: [
          {
            id: 456,
            name: 'Test Inbox',
            username: 'test@inbox.mailtrap.io'
          }
        ]
      )

      expect(project.inboxes).to eq([
                                      {
                                        id: 456,
                                        name: 'Test Inbox',
                                        username: 'test@inbox.mailtrap.io'
                                      }
                                    ])
    end
  end
end
