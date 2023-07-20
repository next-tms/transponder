module Transponder
  module GraphQL
    module Queries
      class Document < Transponder::GraphQL::Types::BaseInterstellarResolver
        type ::Transponder::GraphQL::Types::DocumentResponseType, null: true

        argument :document_type, ::Transponder::GraphQL::Types::DocumentCategory, required: true
        argument :tracking_number, String, required: true

        def call(document_type:, tracking_number:)
          response = interstellar_client.send(document_type, tracking_number)
          Hanami.logger.debug(response.inspect)
          response
        end
      end
    end
  end
end
