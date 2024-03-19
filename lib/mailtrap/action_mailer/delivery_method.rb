# frozen_string_literal: true

module Mailtrap
  module ActionMailer
    class DeliveryMethod
      attr_accessor :settings

      def initialize(settings)
        self.settings = settings
      end

      def deliver!(message)
        mail = Mailtrap::Mail.from_message(message)

        client.send(mail)
      end

      private

      def client
        @client ||= Mailtrap::Client.new(**settings.slice(:api_key, :api_host, :api_port))
      end
    end
  end
end
