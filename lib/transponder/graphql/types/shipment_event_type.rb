# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class ShipmentEventType < BaseObject
        field :type_code, String
        field :date_time, Types::FreightKitDateTimeType
        field :location, Types::FreightKitLocationType
      end
    end
  end
end
