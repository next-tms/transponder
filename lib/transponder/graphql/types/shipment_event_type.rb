# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class ShipmentEventType < BaseObject
        field :date_time, Types::FreightKitDateTimeType
        field :location, Types::FreightKitLocationType
        field :type_code, String
      end
    end
  end
end
