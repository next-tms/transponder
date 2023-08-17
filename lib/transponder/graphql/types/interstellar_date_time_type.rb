# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class InterstellarDateTimeType < BaseObject
        field :local_date_time, String, null: true
        field :local_date, String, null: true
        field :date_time_with_zone, ::GraphQL::Types::ISO8601DateTime, null: true
        field :date_time_with_zone_name, String, null: true
        field :location, Types::InterstellarLocationType

        def date_time_with_zone_name
          return unless object.date_time_with_zone
          
          object.date_time_with_zone.time_zone.name
        end
      end
    end
  end
end
