# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class TrackingResponseType < BaseObject
        field :actual_delivery_date, Types::FreightKitDateTimeType
        field :shipment_events, [Types::ShipmentEventType]
        field :attempted_delivery_date, Types::FreightKitDateTimeType
        field :delivery_signature, String
        field :destination, Types::FreightKitLocationType
        field :estimated_delivery_date, Types::FreightKitDateTimeType
        field :origin, Types::FreightKitLocationType
        field :scheduled_delivery_date, Types::FreightKitDateTimeType
        field :ship_time, Types::FreightKitDateTimeType
        field :shipper_address, String
        field :status, String
        field :status_code, String
        field :status_description, String
        field :tracking_number, String
        field :request, ::GraphQL::Types::JSON, null: true
        field :response, ::GraphQL::Types::JSON, null: true
        field :error, String, null: true
      end
    end
  end
end
