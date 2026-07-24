# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for the result of a reply, reply-all, or forward.
  # @see https://docs.mailtrap.io/developers/inbound
  # @attr_reader message_ids [Array<String>] UUIDs of the sent messages, one per recipient
  InboundSendResult = Struct.new(
    :message_ids,
    keyword_init: true
  )
end
