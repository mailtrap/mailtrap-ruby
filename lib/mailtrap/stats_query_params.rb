# frozen_string_literal: true

require 'date'

module Mailtrap
  # Query parameters of the sending stats and Email Marketing stats endpoints: the period as
  # +YYYY-MM-DD+ dates and every array filter as a repeated +key[]+ parameter.
  module StatsQueryParams
    private

    def build_query_params(start_date, end_date, filters)
      {
        start_date: normalize_date(start_date),
        end_date: normalize_date(end_date),
        **filters.compact.transform_keys { |filter_key| "#{filter_key}[]" }
      }
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
