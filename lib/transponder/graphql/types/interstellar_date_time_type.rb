# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class FreightKitDateTimeType < BaseObject
        field :local_date_time, String, null: true
        field :local_date, String, null: true
        field :date_time_with_zone, String, null: true
        field :location, Types::FreightKitLocationType
      end
    end
  end
end
