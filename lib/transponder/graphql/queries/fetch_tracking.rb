# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class FetchTracking < ::GraphQL::Schema::Resolver
        EXCEPTIONS = {
                       ::FreightKit::InvalidCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
                       ::FreightKit::ResponseError => { code: 'API_ERROR' },
                       ::FreightKit::ShipmentNotFoundError => { code: 'NOT_FOUND' },
                       ::NotImplementedError => { code: 'NOT_IMPLEMENTED_ERROR' },
                       Types::CarrierInputType::CarrierNotFoundError => { code: 'CARRIER_NOT_KNOWN_ERROR' }
                     }

        type ::Transponder::GraphQL::Types::TrackingResponseType, null: true

        argument :carrier, Types::CarrierInputType, required: true
        argument :tracking_number, String, required: true

        def resolve(carrier:, tracking_number:)
          carrier.find_tracking_info(tracking_number)
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
