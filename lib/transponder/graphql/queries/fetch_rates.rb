# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class FetchRates < ::GraphQL::Schema::Resolver
        type ::Transponder::GraphQL::Types::RateResponseType, null: true

        argument :carrier, Types::CarrierInputType, required: true
        argument :shipment, Types::ShipmentInputType, required: true

        def resolve(carrier:, shipment:)
          carrier.find_rates(shipment:)
        rescue ::FreightKit::UnserviceableError => e
          raise ::GraphQL::ExecutionError, e.message.presence || 'Shipment not serviceable by carrier'
        rescue NotImplementedError
          raise ::GraphQL::ExecutionError, 'Rating not supported by carrier'
        rescue Types::CarrierInputType::CarrierNotFoundError => e
          raise ::GraphQL::ExecutionError, e.message
        end
      end
    end
  end
end
