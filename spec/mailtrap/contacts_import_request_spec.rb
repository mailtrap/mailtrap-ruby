# frozen_string_literal: true

RSpec.describe Mailtrap::ContactsImportRequest do
  describe '#upsert' do
    it 'adds contact to the request' do
      request = described_class.new.tap do |req|
        req.upsert(email: 'one@example.com')
           .upsert(email: 'two@example.com', fields: { first_name: 'John', last_name: 'Doe' })
           .upsert(email: 'trhee@example.com', fields: { first_name: 'Jack' })
           .upsert(email: 'trhee@example.com', fields: { first_name: 'Joe', last_name: 'Blow', age: 33 })
      end
      expect(request.to_a).to contain_exactly(
        hash_including(email: 'one@example.com', fields: {}),
        hash_including(email: 'two@example.com', fields: { first_name: 'John', last_name: 'Doe' }),
        hash_including(email: 'trhee@example.com', fields: { first_name: 'Joe', last_name: 'Blow', age: 33 })
      )
    end
  end

  describe '#add_to_lists' do
    it 'does not allow empty list' do
      expect { described_class.new.add_to_lists(email: 'one@example.com', list_ids: []) }.to raise_error(ArgumentError)
    end

    it 'adds contact to the lists' do
      request = described_class.new.tap do |req|
        req.add_to_lists(email: 'one@example.com', list_ids: [1])
           .add_to_lists(email: 'two@example.com', list_ids: [1])
           .add_to_lists(email: 'two@example.com', list_ids: [2])
           .add_to_lists(email: 'trhee@example.com', list_ids: [1])
           .add_to_lists(email: 'trhee@example.com', list_ids: [1, 2])
      end
      expect(request.to_a).to contain_exactly(
        hash_including(email: 'one@example.com', list_ids_included: [1]),
        hash_including(email: 'two@example.com', list_ids_included: [1, 2]),
        hash_including(email: 'trhee@example.com', list_ids_included: [1, 2])
      )
    end
  end

  describe '#remove_from_lists' do
    it 'does not allow empty list' do
      expect do
        described_class.new.remove_from_lists(email: 'one@example.com', list_ids: [])
      end.to raise_error(ArgumentError)
    end

    it 'adds contact to the lists' do
      request = described_class.new.tap do |req|
        req.remove_from_lists(email: 'one@example.com', list_ids: [1])
           .remove_from_lists(email: 'two@example.com', list_ids: [1])
           .remove_from_lists(email: 'two@example.com', list_ids: [2])
           .remove_from_lists(email: 'trhee@example.com', list_ids: [1])
           .remove_from_lists(email: 'trhee@example.com', list_ids: [1, 2])
      end
      expect(request.to_a).to contain_exactly(
        hash_including(email: 'one@example.com', list_ids_excluded: [1]),
        hash_including(email: 'two@example.com', list_ids_excluded: [1, 2]),
        hash_including(email: 'trhee@example.com', list_ids_excluded: [1, 2])
      )
    end
  end

  describe '#to_a' do
    it 'returns json array' do
      request = described_class.new
      expect(request.to_a).to eq([])

      request.upsert(email: 'one@example.com', fields: { first_name: 'John' })
      expect(request.to_a).to contain_exactly(
        { email: 'one@example.com', fields: { first_name: 'John' }, list_ids_included: [], list_ids_excluded: [] }
      )
    end
  end

  it 'supports multiple operations on one contact' do
    request = described_class.new.tap do |req|
      req.upsert(email: 'one@example.com', fields: { first_name: 'John' })
         .add_to_lists(email: 'one@example.com', list_ids: [1])
         .remove_from_lists(email: 'one@example.com', list_ids: [2])

      req.remove_from_lists(email: 'two@example.com', list_ids: [12])
         .add_to_lists(email: 'two@example.com', list_ids: [11])
         .upsert(email: 'two@example.com', fields: { first_name: 'Jack' })
    end
    expect(request.to_a).to contain_exactly(
      { email: 'one@example.com', fields: { first_name: 'John' }, list_ids_included: [1], list_ids_excluded: [2] },
      { email: 'two@example.com', fields: { first_name: 'Jack' }, list_ids_included: [11], list_ids_excluded: [12] }
    )
  end
end
