# frozen_string_literal: true

module Transponder
  module GraphQL
    module Mutations
      class CreatePickup < ::GraphQL::Schema::Resolver
        type ::Transponder::GraphQL::Types::PickupResponseType, null: false

        argument :carrier, Types::CarrierInputType, required: true
        argument :delivery_from, ::GraphQL::Types::ISO8601DateTime, required: false
        argument :delivery_to, ::GraphQL::Types::ISO8601DateTime, required: false
        argument :dispatcher, ::Transponder::GraphQL::Types::ContactInputType, required: true
        argument :pickup_from, ::GraphQL::Types::ISO8601DateTime, required: true
        argument :pickup_to, ::GraphQL::Types::ISO8601DateTime, required: true
        argument :scac, String, required: true
        argument :service, String, required: false
        argument :shipment, ::Transponder::GraphQL::Types::ShipmentInputType, required: true

        def resolve(carrier:, delivery_from: nil, delivery_to: nil, dispatcher:, pickup_from:, pickup_to:, scac:,
          service: nil, shipment:)
          carrier.create_pickup(
            delivery_from:,
            delivery_to:,
            dispatcher:,
            pickup_from:,
            pickup_to:,
            scac:,
            service:,
            shipment:,
          )
        end
      end
    end
  end
end
