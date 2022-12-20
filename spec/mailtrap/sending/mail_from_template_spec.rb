# frozen_string_literal: true

require_relative './shared'

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe Mailtrap::Sending::MailFromTemplate do
  subject(:mail) do
    described_class.new(
      from: from,
      to: to,
      cc: cc,
      bcc: bcc,
      attachments: attachments,
      headers: headers,
      custom_variables: custom_variables,
      template_uuid: template_uuid,
      template_variables: template_variables
    )
  end

  let(:from) { nil }
  let(:to) { [] }
  let(:cc) { [] }
  let(:bcc) { [] }
  let(:attachments) { [] }
  let(:headers) { {} }
  let(:custom_variables) { {} }
  let(:template_uuid) { nil }
  let(:template_variables) { {} }

  it_behaves_like 'with attachments'

  specify do
    mail.template_uuid = '7a58f94d-d282-4538-ae50-4714eafef80e'
    expect(mail.template_uuid).to eq('7a58f94d-d282-4538-ae50-4714eafef80e')
  end

  specify do
    mail.template_variables = { 'user.name' => 'Jack Daniels' }
    expect(mail.template_variables).to eq('user.name' => 'Jack Daniels')
  end

  context 'when all values set' do
    let(:from) { { email: 'test@example.com', name: 'Mailtrap User' } }
    let(:to) { [{ email: 'to@example.com' }, { email: 'to2@example.com', name: 'To Two' }] }
    let(:cc) { [{ email: 'cc@example.com' }] }
    let(:bcc) { [{ email: 'bcc@example.com' }] }
    let(:html) { '<div>Test HTML</div>' }
    let(:attachments) do
      [
        { content: StringIO.new('hello world'), filename: 'attachment.txt' }
      ]
    end
    let(:headers) { { 'Category-Header' => 'some_category' } }
    let(:category) { 'another_category' }
    let(:custom_variables) { { year: 2022 } }
    let(:template_uuid) { '7a58f94d-d282-4538-ae50-4714eafef80e' }
    let(:template_variables) { { 'user.name' => 'Jack Daniels' } }

    describe '#as_json' do
      subject(:as_json) { mail.as_json }

      let(:expected_hash) do
        {
          'from' => { email: 'test@example.com', name: 'Mailtrap User' },
          'to' => [{ email: 'to@example.com' }, { email: 'to2@example.com', name: 'To Two' }],
          'cc' => [{ email: 'cc@example.com' }],
          'bcc' => [{ email: 'bcc@example.com' }],
          'headers' => { 'Category-Header' => 'some_category' },
          'attachments' => [{ 'content' => 'aGVsbG8gd29ybGQ=', 'filename' => 'attachment.txt' }],
          'custom_variables' => { year: 2022 },
          'template_uuid' => '7a58f94d-d282-4538-ae50-4714eafef80e',
          'template_variables' => { 'user.name' => 'Jack Daniels' }
        }
      end

      specify do
        expect(as_json).to eq(expected_hash)
      end
    end
  end

  context 'when some values set' do
    let(:from) { { email: 'test@example.com', name: 'Mailtrap User' } }
    let(:to) { [{ email: 'to@example.com' }, { email: 'to2@example.com', name: 'To Two' }] }
    let(:mail_subject) { 'This is subject' }
    let(:text) { 'This is text' }

    describe '#as_json' do
      subject(:as_json) { mail.as_json }

      let(:expected_hash) do
        {
          'from' => { email: 'test@example.com', name: 'Mailtrap User' },
          'to' => [{ email: 'to@example.com' }, { email: 'to2@example.com', name: 'To Two' }],
          'cc' => [],
          'bcc' => [],
          'headers' => {},
          'attachments' => [],
          'custom_variables' => {},
          'template_variables' => {}
        }
      end

      specify do
        expect(as_json).to eq(expected_hash)
      end
    end
  end

  describe '#to_json' do
    subject(:to_json) { mail.to_json }

    let(:from) { { email: 'test@example.com', name: 'Mailtrap User' } }
    let(:to) { [{ email: 'to@example.com' }, { email: 'to2@example.com', name: 'To Two' }] }
    let(:cc) { [{ email: 'cc@example.com' }] }
    let(:bcc) { [{ email: 'bcc@example.com' }] }
    let(:attachments) { [{ content: StringIO.new('hello world'), filename: 'attachment.txt' }] }
    let(:headers) { { 'Category-Header' => 'some_category' } }
    let(:template_uuid) { '7a58f94d-d282-4538-ae50-4714eafef80e' }
    let(:template_variables) { { 'user.name' => 'Jack Daniels' } }
    let(:expected_json) do
      '{' \
        '"to":[{"email":"to@example.com"},{"email":"to2@example.com","name":"To Two"}],' \
        '"from":{"email":"test@example.com","name":"Mailtrap User"},' \
        '"cc":[{"email":"cc@example.com"}],' \
        '"bcc":[{"email":"bcc@example.com"}],' \
        '"attachments":[{"content":"aGVsbG8gd29ybGQ=","filename":"attachment.txt"}],' \
        '"headers":{"Category-Header":"some_category"},' \
        '"custom_variables":{},' \
        '"template_uuid":"7a58f94d-d282-4538-ae50-4714eafef80e",' \
        '"template_variables":{"user.name":"Jack Daniels"}' \
        '}'
    end

    specify do
      expect(to_json).to eq(expected_json)
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
