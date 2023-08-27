# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class Document < Transponder::GraphQL::Types::BaseFreightKitResolver
        type ::Transponder::GraphQL::Types::DocumentResponseType, null: true

        argument :document_type, ::Transponder::GraphQL::Types::DocumentCategory, required: true
        argument :tracking_number, String, required: true

        def call(document_type:, tracking_number:)
          freight_kit_client.send(document_type, tracking_number)
        rescue NotImplementedError
          message = "#{document_type} retrieval not supported by carrier"
          raise ::GraphQL::ExecutionError, message
        end
      end
    end
  end
end
