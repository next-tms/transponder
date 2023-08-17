# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class PickupResponseType < BaseObject
        field :pickup_number, String, null: true
        field :request, ::GraphQL::Types::JSON, null: true
        field :response, ::GraphQL::Types::JSON, null: true
        field :error, String, null: true
        field :labels, [Types::PickupLabelType], null: true
      end
    end
  end
end
