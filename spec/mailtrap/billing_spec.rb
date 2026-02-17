# frozen_string_literal: true

RSpec.describe Mailtrap::Billing do
  describe '#initialize' do
    subject(:billing) { described_class.new(attributes) }

    let(:attributes) do
      {
        billing: {
          cycle_start: '2024-02-15T21:11:59.624Z',
          cycle_end: '2024-02-15T21:11:59.624Z'
        },
        testing: {
          plan: {
            name: 'Individual'
          },
          usage: {
            sent_messages_count: {
              current: 1234,
              limit: 5000
            },
            forwarded_messages_count: {
              current: 0,
              limit: 100
            }
          }
        },
        sending: {
          plan: {
            name: 'Basic 10K'
          },
          usage: {
            sent_messages_count: {
              current: 6789,
              limit: 10_000
            }
          }
        }
      }
    end

    it 'creates a billing data with all attributes' do
      expect(billing).to match_struct(
        billing: {
          cycle_start: '2024-02-15T21:11:59.624Z',
          cycle_end: '2024-02-15T21:11:59.624Z'
        },
        testing: {
          plan: {
            name: 'Individual'
          },
          usage: {
            sent_messages_count: {
              current: 1234,
              limit: 5000
            },
            forwarded_messages_count: {
              current: 0,
              limit: 100
            }
          }
        },
        sending: {
          plan: {
            name: 'Basic 10K'
          },
          usage: {
            sent_messages_count: {
              current: 6789,
              limit: 10_000
            }
          }
        }
      )
    end
  end
end
