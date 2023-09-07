# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class FileType < BaseObject
        field :content_type, String, null: false
        field :data_base64, String, description: 'Bineary content encoded as Base64', null: false
      end
    end
  end
end
