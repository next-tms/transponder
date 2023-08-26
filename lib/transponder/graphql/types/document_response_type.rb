# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class DocumentResponseType < BaseObject
        field :content_type, String, null: true
        field :data, String, null: true
        field :error, String, null: true
        field :request, String

        def data
          return unless object.data

          # Handle non UTF-8 string responses from Document Response
          Base64.encode64(object.data)
        end
      end
    end
  end
end
