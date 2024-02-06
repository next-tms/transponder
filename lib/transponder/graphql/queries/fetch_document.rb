# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class FetchDocument < ::GraphQL::Schema::Resolver
        type ::Transponder::GraphQL::Types::DocumentResponseType, null: true

        argument :carrier, Types::CarrierInputType, required: true
        argument :document_type, ::Transponder::GraphQL::Types::DocumentCategory, required: true
        argument :tracking_number, String, required: true

        def resolve(carrier:, document_type:, tracking_number:)
          carrier.public_send(document_type, tracking_number)
        rescue NotImplementedError
          message = "#{document_type} retrieval not supported by carrier"
          raise ::GraphQL::ExecutionError, message, extensions: { code: 'NOT_IMPLEMENTED_ERROR' }
        end
      end
    end
  end
end
