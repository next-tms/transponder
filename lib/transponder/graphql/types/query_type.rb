# frozen_string_literal: true

require "interstellar"
require "interstellar-next"

module Transponder
  module GraphQL
    module Types
      class QueryType < BaseObject
        # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
        include ::GraphQL::Types::Relay::HasNodeField
        include ::GraphQL::Types::Relay::HasNodesField

        field :tracking_info, resolver: ::Transponder::GraphQL::Queries::Tracking
        field :document, resolver: ::Transponder::GraphQL::Queries::Document
      end
    end
  end
end
