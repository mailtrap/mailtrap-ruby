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
        }
      )

      expect(project.inboxes.map(&:to_h)).to eq([
                                                  {
                                                    id: 456,
                                                    name: 'Test Inbox',
                                                    username: 'test@inbox.mailtrap.io'
                                                  }
                                                ])
    end
  end

  describe '#to_h' do
    subject(:hash) { project.to_h }

    let(:project) do
      described_class.new(
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
      )
    end

    it 'returns a hash with all attributes' do
      expect(hash).to eq(
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
      )
    end
  end
end
