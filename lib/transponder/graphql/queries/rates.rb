# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class Rates < Transponder::GraphQL::Types::BaseFreightKitResolver
        include ::Transponder::GraphQL::Concerns::FreightKitHelper

        type ::Transponder::GraphQL::Types::RateResponseType, null: true

        argument :accessorials, [String], required: false
        argument :destination, Transponder::GraphQL::Types::LocationInputType, required: false
        argument :origin, Transponder::GraphQL::Types::LocationInputType, required: false
        argument :packages, [Transponder::GraphQL::Types::PackageInputType], required: true
        argument :pickup_at, ::GraphQL::Types::ISO8601DateTime, required: false
        argument :value_cents, Float, required: false

        def call(**args)
          shipment = build_freight_kit_shipment(args)
          Hanami.logger.debug(shipment.inspect)
          begin
            response = freight_kit_client.find_rates(shipment: shipment)
          rescue NotImplementedError
            raise ::GraphQL::ExecutionError, 'No rates returned from the API'
          end
          response
        end
      end
    end
  end
end
