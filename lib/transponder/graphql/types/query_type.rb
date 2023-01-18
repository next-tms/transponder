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

        multiple_fields ::Transponder::GraphQL::Queries::Carrier,
                        ::Transponder::GraphQL::Queries::Tracking
      end
    end
  end
end
