# frozen_string_literal: true

RSpec.describe Mailtrap::SandboxMessagesAPI, :vcr do
  subject(:sandbox_messages_api) { described_class.new(account_id, inbox_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }
  let(:inbox_id) { ENV.fetch('MAILTRAP_INBOX_ID', 4_288_340) }

  describe '#get' do
    subject(:get) { sandbox_messages_api.get(sandbox_message_id) }

    let(:sandbox_message_id) { 5_273_448_410 }

    it 'maps response data to SandboxMessage object' do
      expect(get).to be_a(Mailtrap::SandboxMessage)

      expect(get).to have_attributes(
        id: 5_273_448_410,
        inbox_id: 4_288_340,
        subject: 'Hello from Mailtrap',
        sent_at: '2026-01-04T04:55:50.867-12:00',
        from_email: 'reply@demomailtrap.co',
        from_name: '',
        to_email: 'alex.b@railsware.com',
        to_name: '',
        email_size: 691,
        is_read: true,
        created_at: '2026-01-04T04:55:50.871-12:00',
        updated_at: '2026-01-04T04:55:56.618-12:00',
        html_body_size: 29,
        text_body_size: 20,
        human_size: '691 Bytes',
        blacklists_report_info: {
          result: 'success',
          domain: 'demomailtrap.co',
          ip: '172.67.134.80',
          report: [
            { name: 'BACKSCATTERER', url: 'http://www.backscatterer.org/index.php', in_black_list: false },
            { name: 'BARRACUDA', url: 'http://barracudacentral.org/rbl', in_black_list: false },
            { name: 'Spamrbl IMP-SPAM', url: 'http://antispam.imp.ch/?lng=1', in_black_list: false },
            { name: 'Wormrbl IMP-SPAM', url: 'http://antispam.imp.ch/?lng=1', in_black_list: false },
            { name: 'LASHBACK', url: 'http://blacklist.lashback.com/', in_black_list: false },
            { name: 'NIXSPAM', url: 'https://www.heise.de/ix/NiX-Spam-DNSBL-and-blacklist-for-download-499637.html',
              in_black_list: false },
            { name: 'PSBL', url: 'https://psbl.org/', in_black_list: false },
            { name: 'SORBS-SPAM', url: 'http://www.sorbs.net/lookup.shtml', in_black_list: false },
            { name: 'SPAMCOP', url: 'http://spamcop.net/bl.shtml', in_black_list: false },
            { name: 'TRUNCATE', url: 'http://www.gbudb.com/truncate/index.jsp', in_black_list: false }
          ]
        },
        smtp_information: { ok: false }
      )
    end

    context 'when SandboxMessage does not exist' do
      let(:sandbox_message_id) { 999_999 }

      it 'raises not found error' do
        expect { get }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#update' do
    subject(:update) { sandbox_messages_api.update(sandbox_message_id, **request) }

    let(:sandbox_message_id) { 5_273_448_410 }
    let(:request) do
      {
        is_read: true
      }
    end

    it 'maps response data to SandboxMessage object' do
      expect(update).to be_a(Mailtrap::SandboxMessage)
      expect(update).to have_attributes(
        is_read: true
      )
    end

    context 'when SandboxMessage does not exist' do
      let(:sandbox_message_id) { 999_999 }

      it 'raises not found error' do
        expect { update }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#list' do
    subject(:list) { sandbox_messages_api.list }

    it 'validates arguments' do
      expect { sandbox_messages_api.list(page: 1, last_id: 1) }.to raise_error(ArgumentError)
    end

    it 'maps response data to SandboxMessage objects' do
      expect(list).to all(be_a(Mailtrap::SandboxMessage))
      expect(list.size).to eq(5)
    end

    context 'with parameters' do
      subject(:list) { sandbox_messages_api.list(search: 'alex.d', last_id:) }

      let(:last_id) { 5_273_671_943 }

      it 'maps response data to SandboxMessage objects' do
        expect(list).to all(be_a(Mailtrap::SandboxMessage))
        expect(list.size).to eq(1)
      end

      context 'when last_id includes more messages' do
        let(:last_id) { 5_273_671_999 }

        it 'maps response data to SandboxMessage objects' do
          expect(list).to all(be_a(Mailtrap::SandboxMessage))
          expect(list.size).to eq(2)
        end
      end
    end

    context 'when api key is incorrect' do
      let(:client) { Mailtrap::Client.new(api_key: 'incorrect-api-key') }

      it 'raises authorization error' do
        expect { list }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::AuthorizationError)
          expect(error.message).to include('Incorrect API token')
          expect(error.messages.any? { |msg| msg.include?('Incorrect API token') }).to be true
        end
      end
    end
  end

  describe '#forward_message' do
    subject(:forward_message) do
      sandbox_messages_api.forward_message(message_id: sandbox_message_id, email: 'example@railsware.com')
    end

    let(:sandbox_message_id) { 5_273_448_410 }

    it 'returns success' do
      expect(forward_message).to eq({ message: 'Your email message has been successfully forwarded',
                                      success: true })
    end

    context 'when sandbox message does not exist' do
      let(:sandbox_message_id) { -1 }

      it 'raises not found error' do
        expect { forward_message }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#spam_score' do
    subject(:spam_score) do
      sandbox_messages_api.spam_score(sandbox_message_id)
    end

    let(:sandbox_message_id) { 5_273_448_410 }

    it 'returns report' do
      expect(spam_score).to eq(
        { report:
           { ResponseCode: 0,
             ResponseMessage: 'EX_OK',
             ResponseVersion: '1.1',
             Score: 0.1,
             Spam: false,
             Threshold: 5.0,
             Details: [
               { Pts: '0.1', RuleName: 'MISSING_MID', Description: 'Missing Message-Id: header' },
               { Pts: '0.0', RuleName: 'HTML_MESSAGE', Description: 'BODY: HTML included in message' }
             ] } }
      )
    end

    context 'when sandbox message does not exist' do
      let(:sandbox_message_id) { -1 }

      it 'raises not found error' do
        expect { spam_score }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#html_analysis' do
    subject(:html_analysis) do
      sandbox_messages_api.html_analysis(sandbox_message_id)
    end

    let(:sandbox_message_id) { 5_273_448_410 }

    it 'returns html analysis' do
      expect(html_analysis).to eq({ report: { status: 'success', errors: [] } })
    end

    context 'when sandbox message does not exist' do
      let(:sandbox_message_id) { -1 }

      it 'raises not found error' do
        expect { html_analysis }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#text_body' do
    subject(:text_body) do
      sandbox_messages_api.text_body(sandbox_message_id)
    end

    let(:sandbox_message_id) { 5_273_448_410 }

    it 'returns text message' do
      expect(text_body).to eq('Welcome to Mailtrap!')
    end

    context 'when sandbox message does not exist' do
      let(:sandbox_message_id) { -1 }

      it 'raises not found error' do
        expect { text_body }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#raw_body' do
    subject(:raw_body) do
      sandbox_messages_api.raw_body(sandbox_message_id)
    end

    let(:sandbox_message_id) { 5_273_448_410 }

    it 'returns raw message' do
      expect(raw_body).to include('Welcome to Mailtrap!')
      expect(raw_body).to include('MIME-Version: 1.0')
      expect(raw_body).to include('Subject: Hello from Mailtrap')
    end

    context 'when sandbox message does not exist' do
      let(:sandbox_message_id) { -1 }

      it 'raises not found error' do
        expect { raw_body }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#html_source' do
    subject(:html_source) do
      sandbox_messages_api.html_source(sandbox_message_id)
    end

    let(:sandbox_message_id) { 5_273_448_410 }

    it 'returns html source message' do
      expect(html_source).to eq('<h1>Welcome to Mailtrap!</h1>')
    end

    context 'when sandbox message does not exist' do
      let(:sandbox_message_id) { -1 }

      it 'raises not found error' do
        expect { html_source }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#html_body' do
    subject(:html_body) do
      sandbox_messages_api.html_body(sandbox_message_id)
    end

    let(:sandbox_message_id) { 5_273_448_410 }

    it 'returns html message' do
      expect(html_body).to eq('<h1>Welcome to Mailtrap!</h1>')
    end

    context 'when sandbox message does not exist' do
      let(:sandbox_message_id) { -1 }

      it 'raises not found error' do
        expect { html_body }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#eml_body' do
    subject(:eml_body) do
      sandbox_messages_api.eml_body(sandbox_message_id)
    end

    let(:sandbox_message_id) { 5_273_448_410 }

    it 'returns eml message' do
      expect(eml_body).to include('Welcome to Mailtrap!')
      expect(eml_body).to include('MIME-Version: 1.0')
      expect(eml_body).to include('Subject: Hello from Mailtrap')
    end

    context 'when sandbox message does not exist' do
      let(:sandbox_message_id) { -1 }

      it 'raises not found error' do
        expect { eml_body }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#mail_headers' do
    subject(:mail_headers) do
      sandbox_messages_api.mail_headers(sandbox_message_id)
    end

    let(:sandbox_message_id) { 5_273_448_410 }

    it 'returns headers' do
      expect(mail_headers).to eq(
        {
          headers:
            {
              date: 'Tue, 30 Dec 2025 16:55:50 +0000',
              from: 'reply@demomailtrap.co',
              to: 'bob.s@railsware.com',
              subject: 'Hello from Mailtrap',
              mime_version: '1.0',
              content_type: 'multipart/alternative; boundary=123',
              bcc: 'not available for your plan'
            }
        }
      )
    end

    context 'when sandbox message does not exist' do
      let(:sandbox_message_id) { -1 }

      it 'raises not found error' do
        expect { mail_headers }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#delete' do
    subject(:delete) { sandbox_messages_api.delete(sandbox_message_id) }

    let(:sandbox_message_id) { 5_273_448_410 }

    it 'returns deleted project id' do
      expect(delete[:id]).to eq(sandbox_message_id)
    end

    context 'when message does not exist' do
      let(:sandbox_message_id) { 999_999 }

      it 'raises not found error' do
        expect { delete }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end
end
