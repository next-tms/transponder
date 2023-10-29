# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class TrackingResponseType < BaseObject
        field :actual_delivery, Types::DateTimeType, method: :actual_delivery_date
        field :actual_pickup, Types::DateTimeType, method: :ship_time
        field :attempted_delivery, Types::DateTimeType, method: :attempted_delivery_date
        field :delivery_signature, String
        field :destination, Types::LocationType
        field :error, String, null: true
        field :estimated_delivery, Types::DateTimeType, method: :estimated_delivery_date
        field :events, [Types::Event], method: :shipment_events
        field :origin, Types::LocationType
        field :request, ::GraphQL::Types::JSON, null: true
        field :response, ::GraphQL::Types::JSON, null: true
        field :scheduled_delivery, Types::DateTimeType, method: :scheduled_delivery_date
        field :tracking_number, String
      end
    end
  end
end
