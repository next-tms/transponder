module Transponder
  module GraphQL
    module Mutations
      class CreatePickup < ::GraphQL::Schema::Resolver
        include CarrierErrors

        EXCEPTIONS = {
          ::FreightKit::ExpiredCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
          ::FreightKit::HTTPError => { code: 'API_ERROR' },
          ::FreightKit::InvalidCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
          ::FreightKit::ResponseError => { code: 'API_ERROR' },
          ::FreightKit::UnserviceableAccessorialsError => { code: 'NOT_SERVICEABLE_ERROR' },
          ::FreightKit::UnserviceableError => { code: 'NOT_SERVICEABLE_ERROR' },
          ::HTTPX::Error => { code: 'API_ERROR' },
          ::NotImplementedError => { code: 'NOT_IMPLEMENTED_ERROR' },
          Types::CarrierInputType::CarrierNotFoundError => { code: 'CARRIER_NOT_KNOWN_ERROR' }
        }.freeze

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

        def resolve( # rubocop:disable Metrics/ParameterLists
          carrier:,
          dispatcher:,
          pickup_from:,
          pickup_to:,
          scac:,
          shipment:,
          delivery_from: nil,
          delivery_to: nil,
          service: nil
        )
          result = carrier.create_pickup(delivery_from:, delivery_to:, dispatcher:, pickup_from:, pickup_to:, scac:, service:, shipment:)
          return result if result.error.blank?

          raise result.error
        rescue *EXCEPTIONS.keys => e
          raise_error(e)
        end
      end
    end
  end
end
