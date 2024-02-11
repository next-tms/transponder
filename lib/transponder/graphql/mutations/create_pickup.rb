# frozen_string_literal: true

module Transponder
  module GraphQL
    module Mutations
      class CreatePickup < ::GraphQL::Schema::Resolver
        EXCEPTIONS = {
                       ::FreightKit::ExpiredCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
                       ::FreightKit::InvalidCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
                       ::FreightKit::ResponseError => { code: 'API_ERROR' },
                       ::FreightKit::UnserviceableAccessorialsError => { code: 'NOT_SERVICEABLE_ERROR' },
                       ::FreightKit::UnserviceableError => { code: 'NOT_SERVICEABLE_ERROR' },
                       ::NotImplementedError => { code: 'NOT_IMPLEMENTED_ERROR' },
                       Types::CarrierInputType::CarrierNotFoundError => { code: 'CARRIER_NOT_KNOWN_ERROR' }
                     }

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

        def resolve(
          carrier:,
          delivery_from: nil,
          delivery_to: nil,
          dispatcher:,
          pickup_from:,
          pickup_to:,
          scac:,
          service: nil,
          shipment:
        )
          result = carrier
                   .create_pickup(
                     delivery_from:,
                     delivery_to:,
                     dispatcher:,
                     pickup_from:,
                     pickup_to:,
                     scac:,
                     service:,
                     shipment:,
                   )
          return result if result.error.blank?

          raise result.error
        rescue *EXCEPTIONS.keys => e
          raise_error(e)
        end

        private

        def raise_error(error)
          code = EXCEPTIONS[error.class][:code]
          message = error.message if error.message != error.class.to_s

          context.add_error(::GraphQL::ExecutionError.new(message, extensions: { code: }))
        end
      end
    end
  end
end
