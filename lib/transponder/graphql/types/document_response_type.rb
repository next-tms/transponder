# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class DocumentResponseType < BaseObject
        field :content_type, String
        field :data, String
        field :request, String

        def data
          # Handle non UTF-8 string responses from Document Response
          Base64.encode64(object.data)
        end
      end
    end
  end
end
