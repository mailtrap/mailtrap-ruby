# frozen_string_literal: true

require_relative 'base_api'
require_relative 'account'

module Mailtrap
  class AccountsAPI
    include BaseAPI

    self.response_class = Account

    attr_reader :client

    # @param client [Mailtrap::Client] The client instance
    # @raise [ArgumentError] If account_id is nil
    def initialize(client = Mailtrap::Client.new)
      @client = client
    end

    # Lists all accounts
    # @return [Array<Account>] Array of accounts
    # @!macro api_errors
    def list
      base_list
    end

    private

    def base_path
      '/api/accounts'
    end
  end
end
