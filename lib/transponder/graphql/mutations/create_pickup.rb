module Transponder
  module GraphQL
    module Mutations
      class CreatePickup < Transponder::GraphQL::Types::BaseInterstellarResolver
        include ::Transponder::GraphQL::Concerns::InterstellarHelper

        type ::Transponder::GraphQL::Types::PickupResponseType, null: true
        
        argument :delivery_from, ::GraphQL::Types::ISO8601DateTime, required: false
        argument :delivery_to, ::GraphQL::Types::ISO8601DateTime, required: false
        argument :pickup_from, ::GraphQL::Types::ISO8601DateTime, required: false
        argument :pickup_to, ::GraphQL::Types::ISO8601DateTime, required: false
        argument :service, String, required: false
        argument :dispatcher, ::Transponder::GraphQL::Types::ContactInputType, required: false

        # Shipment related
        argument :accessorials, [String], required: false
        argument :value_cents, Float, required: false
        argument :packages, [Transponder::GraphQL::Types::PackageInputType], required: true
        argument :origin, Transponder::GraphQL::Types::LocationInputType, required: false
        argument :destination, Transponder::GraphQL::Types::LocationInputType, required: false
        argument :po_number, String, required: false
        argument :order_number, String, required: false
        argument :pro, String, required: false

        def call(**args)
          shipment = build_interstellar_shipment(args)

          response = interstellar_client.create_pickup(
            delivery_from: iso8601_to_datetime_with_timezone(args[:delivery_from]),
            delivery_to: iso8601_to_datetime_with_timezone(args[:delivery_to]),
            pickup_from: iso8601_to_datetime_with_timezone(args[:pickup_from]),
            pickup_to: iso8601_to_datetime_with_timezone(args[:pickup_to]),
            dispatcher: Interstellar::Contact.new(**args[:dispatcher]),
            scac: scac,
            service: args[:service],
            shipment:
          )

          Hanami.logger.debug(response.inspect)
          response
        end
      end
    end
  end
end
