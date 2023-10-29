# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class DocumentResponseType < BaseObject
        field :document, Types::FileType, null: true
        field :error, String, null: true
        field :request, String

        def document
          { content_type: document_content_type, data_base64: document_data_base64 }
        end

        private

        def document_content_type
          return unless object.content_type.presence || object.data

          object.content_type.presence || MimeMagic.by_magic(object.data)
        end

        def document_data_base64
          return unless object.data

          # Handle non UTF-8 string responses from Document Response
          Base64.strict_encode64(object.data)
        end
      end
    end
  end
end
