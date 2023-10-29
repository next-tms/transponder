# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class DateTimeType < BaseObject
        field :iso8601, ::GraphQL::Types::ISO8601DateTime, null: true
        field :local_date, String, null: true
        field :local_date_time, String, null: true
        field :location, Types::LocationType
        field :time_zone, String, null: true

        def iso8601
          object.date_time_with_zone&.iso8601
        end

        def local_date_time
          return object.local_date_time if object.local_date_time.present?

          return if object.date_time_with_zone.blank?

          object.date_time_with_zone.iso8601[..-7]
        end

        def local_date
          return object.local_date if object.local_date.present?

          return if object.date_time_with_zone.blank?

          object.date_time_with_zone.iso8601[..9]
        end

        def time_zone
          return unless object.date_time_with_zone

          object.date_time_with_zone.time_zone.name
        end
      end
    end
  end
end
