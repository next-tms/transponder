# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class TrackingResponseType < BaseObject
        field :actual_delivery_date, String
        field :shipment_events, [Types::ShipmentEventType]
        field :attempted_delivery_date, String
        field :delivery_signature, String
        field :destination, Types::InterstellarLocationType
        field :estimated_delivery_date, String
        field :origin, Types::InterstellarLocationType
        field :scheduled_delivery_date, String
        field :ship_time, String
        field :shipper_address, String
        field :status, String
        field :status_code, String
        field :status_description, String
        field :tracking_number, String
      end
    end
  end
end
