# frozen_string_literal: true

require 'date'

module Mailtrap
  # Query parameters of the sending stats and Email Marketing stats endpoints: the period as
  # +YYYY-MM-DD+ dates and every array filter as a repeated +key[]+ parameter. A +nil+ or empty
  # filter is left out.
  module StatsQueryParams
    private

    def build_query_params(start_date, end_date, filters)
      params = { start_date: normalize_date(start_date), end_date: normalize_date(end_date) }
      filters.each { |filter_key, values| params["#{filter_key}[]"] = values unless Array(values).empty? }
      params
    end

    def normalize_date(value)
      case value
      when Date, Time # DateTime is a Date, but its #iso8601 includes the time of day
        return value.strftime('%F')
      when String
        return value if /\A\d{4}-\d{2}-\d{2}\z/.match?(value) && Date.valid_date?(*value.split('-').map(&:to_i))
      end

      raise ArgumentError, "Invalid date: #{value.inspect}. Expected a Date, Time, or String in YYYY-MM-DD format."
    end
  end
end
