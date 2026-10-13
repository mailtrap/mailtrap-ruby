# frozen_string_literal: true

require 'date'

module Mailtrap
  # Query parameters of the sending stats and Email Marketing stats endpoints: the period as
  # +YYYY-MM-DD+ dates and every array filter as a repeated +key[]+ parameter.
  module StatsQueryParams
    private

    def build_query_params(start_date, end_date, filters)
      params = { start_date: normalize_date(start_date), end_date: normalize_date(end_date) }

      filters.compact.each { |filter_key, values| params["#{filter_key}[]"] = values }

      params
    end

    def normalize_date(value)
      case value
      when Date
        value.iso8601
      when Time
        value.strftime('%F')
      when String
        unless /\A\d{4}-\d{2}-\d{2}\z/.match?(value)
          raise ArgumentError,
                "Invalid date: #{value.inspect}. Expected a Date, Time, or String in YYYY-MM-DD format."
        end

        Date.iso8601(value).iso8601
      else
        raise ArgumentError,
              "Invalid date: #{value.inspect}. Expected a Date, Time, or String in YYYY-MM-DD format."
      end
    rescue Date::Error
      raise ArgumentError, "Invalid date: #{value.inspect}. Expected a Date, Time, or String in YYYY-MM-DD format."
    end
  end
end
