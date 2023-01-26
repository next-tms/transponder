# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class DocumentResponseType < BaseObject
        field :request, String
        field :data, String
        field :content_type, String
      end
    end
  end
end
