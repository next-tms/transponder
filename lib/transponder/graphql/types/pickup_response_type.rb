# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class PickupResponseType < BaseObject
        field :error, String, null: true
        field :labels, [Types::FileType], null: false
        field :pickup_number, String, null: true
        field :request, ::GraphQL::Types::JSON, null: false
        field :response, ::GraphQL::Types::JSON, null: false

        def labels
          return [] if object.labels.blank?

          object.labels.map do |label|
            {
              content_type: label_content_type(label),
              data_base64: label_data_base64(label)
            }
          end
        end

        private

        def label_content_type(label)
          return unless label.content_type.presence || label.data

          label.content_type.presence || MimeMagic.by_magic(label.data)
        end

        def label_data_base64(label)
          return unless label.data

          # Handle non UTF-8 string responses from Document Response
          Base64.strict_encode64(label.data)
        end
      end
    end
  end
end
