# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class RateResponseType < BaseObject
        field :rates, [Types::RateType]
        field :request, ::GraphQL::Types::JSON, null: true
        field :response, ::GraphQL::Types::JSON, null: true
        field :error, String, null: true
      end
    end
  end
end
