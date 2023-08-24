# frozen_string_literal: true

module Transponder
  module GraphQL
    module Mutations
      class CreatePickup < Transponder::GraphQL::Types::BaseFreightKitResolver
        include ::Transponder::GraphQL::Concerns::FreightKitHelper

        type ::Transponder::GraphQL::Types::PickupResponseType, null: true

        argument :delivery_from, ::GraphQL::Types::ISO8601DateTime, required: false
        argument :delivery_to, ::GraphQL::Types::ISO8601DateTime, required: false
        argument :dispatcher, ::Transponder::GraphQL::Types::ContactInputType, required: false
        argument :pickup_from, ::GraphQL::Types::ISO8601DateTime, required: false
        argument :pickup_to, ::GraphQL::Types::ISO8601DateTime, required: false
        argument :service, String, required: false

        # Shipment related
        argument :accessorials, [String], required: false
        argument :destination, Transponder::GraphQL::Types::LocationInputType, required: false
        argument :order_number, String, required: false
        argument :origin, Transponder::GraphQL::Types::LocationInputType, required: false
        argument :packages, [Transponder::GraphQL::Types::PackageInputType], required: true
        argument :po_number, String, required: false
        argument :pro, String, required: false
        argument :value_cents, Float, required: false

        def call(**args)
          shipment = build_freight_kit_shipment(args)

          response = freight_kit_client.create_pickup(
            delivery_from: iso8601_to_datetime_with_timezone(args[:delivery_from]),
            delivery_to: iso8601_to_datetime_with_timezone(args[:delivery_to]),
            pickup_from: iso8601_to_datetime_with_timezone(args[:pickup_from]),
            pickup_to: iso8601_to_datetime_with_timezone(args[:pickup_to]),
            dispatcher: FreightKit::Contact.new(**args[:dispatcher]),
            scac: scac,
            service: args[:service],
            shipment:,
          )

          Hanami.logger.debug(response.inspect)
          response
        end
      end
    end
  end
end
