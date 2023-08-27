# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class FetchRates < Transponder::GraphQL::Types::BaseFreightKitResolver
        include ::Transponder::GraphQL::Concerns::FreightKitHelper

        type ::Transponder::GraphQL::Types::RateResponseType, null: true

        argument :accessorials, [String], required: false
        argument :destination, Transponder::GraphQL::Types::LocationInputType, required: false
        argument :origin, Transponder::GraphQL::Types::LocationInputType, required: false
        argument :packages, [Transponder::GraphQL::Types::PackageInputType], required: true
        argument :pickup_at, ::GraphQL::Types::ISO8601DateTime, required: false
        argument :tariff, Transponder::GraphQL::Types::TariffInputType, required: false
        argument :value, Transponder::GraphQL::Types::MoneyInputType, required: false

        def call(**args)
          shipment = build_freight_kit_shipment(args)

          freight_kit_client.find_rates(shipment:)
        rescue ::FreightKit::UnserviceableError => e
          raise ::GraphQL::ExecutionError, e.message.presence || 'Shipment not serviceable by carrier'
        rescue NotImplementedError
          raise ::GraphQL::ExecutionError, 'Rating not supported by carrier'
        end
      end
    end
  end
end
