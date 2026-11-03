# frozen_string_literal: true

require_relative '../deprecation'

module Mailtrap
  module ActionMailer
    class DeliveryMethod
      attr_accessor :settings

      ALLOWED_PARAMS = %i[api_key api_host api_port bulk sandbox sandbox_id inbox_id].freeze

      def initialize(settings)
        self.settings = settings
      end

      def deliver!(message)
        mail = Mailtrap::Mail.from_message(message)

        client.send(mail).tap do |resp|
          message['X-MT-Message-IDs'] = resp[:message_ids]
        end
      end

      private

      def client
        @client ||= Mailtrap::Client.new(**client_settings)
      end

      def client_settings
        params = settings.slice(*ALLOWED_PARAMS)
        return params if params[:inbox_id].nil?

        Deprecation.warn('The ActionMailer mailtrap_settings inbox_id', 'sandbox_id')
        # When sandbox_id is set too, Client compares the two and raises if they differ.
        params[:sandbox_id] = params.delete(:inbox_id) if params[:sandbox_id].nil?
        params
      end
    end
  end
end
