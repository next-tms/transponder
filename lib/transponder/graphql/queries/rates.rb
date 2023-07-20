module Transponder
  module GraphQL
    module Queries
      class Rates < Transponder::GraphQL::Types::BaseInterstellarResolver
        include ::Transponder::GraphQL::Concerns::InterstellarHelper

        type ::Transponder::GraphQL::Types::RateResponseType, null: true
        
        argument :accessorials, [String], required: false
        argument :value_cents, Float, required: false
        argument :packages, [Transponder::GraphQL::Types::PackageInputType], required: true
        argument :origin, Transponder::GraphQL::Types::LocationInputType, required: false
        argument :destination, Transponder::GraphQL::Types::LocationInputType, required: false
        argument :pickup_at, ::GraphQL::Types::ISO8601DateTime, required: false

        def call(**args)
          shipment = build_interstellar_shipment(args)
          Hanami.logger.debug(shipment.inspect)

          response = interstellar_client.find_rates(shipment: shipment)
          Hanami.logger.debug(response.inspect)
          response
        end
      end
    end
  end
end
