# frozen_string_literal: true

require_relative 'base_api'
require_relative 'account'

module Mailtrap
  class AccountsAPI
    include BaseAPI

    self.response_class = Account

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
