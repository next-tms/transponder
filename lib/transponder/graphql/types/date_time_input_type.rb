# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class DateTimeInputType < ::GraphQL::Schema::InputObject
        argument :iso8601, ::GraphQL::Types::ISO8601DateTime, required: true

        def prepare
          # rubocop:disable Style/DateTime
          timezone_offset = iso8601.to_datetime.offset.numerator
          tz = ActiveSupport::TimeZone[timezone_offset]

          date_time_with_zone = iso8601.to_datetime.in_time_zone(tz)

          FreightKit::DateTime.new(date_time_with_zone:)
          # rubocop:enable Style/DateTime
        end
      end
    end
  end
end
