# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class FetchDocument < ::GraphQL::Schema::Resolver
        EXCEPTIONS = {
                       ::FreightKit::DocumentNotFoundError => { code: 'NOT_FOUND' },
                       ::FreightKit::ExpiredCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
                       ::FreightKit::InvalidCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
                       ::FreightKit::ResponseError => { code: 'API_ERROR' },
                       ::NotImplementedError => { code: 'NOT_IMPLEMENTED_ERROR' },
                       Types::CarrierInputType::CarrierNotFoundError => { code: 'CARRIER_NOT_KNOWN_ERROR' }
                     }

        type ::Transponder::GraphQL::Types::DocumentResponseType, null: true

        argument :carrier, Types::CarrierInputType, required: true
        argument :document_type, ::Transponder::GraphQL::Types::DocumentCategory, required: true
        argument :tracking_number, String, required: true

        def resolve(carrier:, document_type:, tracking_number:)
          carrier.public_send(document_type, tracking_number)
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
