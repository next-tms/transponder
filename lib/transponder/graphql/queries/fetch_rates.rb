# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class FetchRates < ::GraphQL::Schema::Resolver
        EXCEPTIONS = {
                       ::FreightKit::ExpiredCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
                       ::FreightKit::InvalidCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
                       ::FreightKit::ResponseError => { code: 'API_ERROR' },
                       ::FreightKit::UnserviceableAccessorialsError => { code: 'NOT_SERVICEABLE_ERROR' },
                       ::FreightKit::UnserviceableError => { code: 'NOT_SERVICEABLE_ERROR' },
                       ::NotImplementedError => { code: 'NOT_IMPLEMENTED_ERROR' },
                       Types::CarrierInputType::CarrierNotFoundError => { code: 'CARRIER_NOT_KNOWN_ERROR' }
                     }

        type ::Transponder::GraphQL::Types::RateResponseType, null: true

        argument :carrier, Types::CarrierInputType, required: true
        argument :shipment, Types::ShipmentInputType, required: true

        def resolve(carrier:, shipment:)
          result = carrier.find_rates(shipment:)
          return result if result.error.blank?

          raise result.error
        rescue *EXCEPTIONS.keys => e
          raise_error(e)
        end

        private

        def raise_error(error)
          code = EXCEPTIONS[error.class][:code]
          message = error.message if error.message != error.class.to_s

          context.add_error(::GraphQL::ExecutionError.new(message, extensions: { code: code }))
        end
      end
    end
  end
end
