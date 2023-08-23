# frozen_string_literal: true

require "freight_kit"
require "freight_kit-next"

module Transponder
  module GraphQL
    module Types
      class QueryType < BaseObject
        # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
        include ::GraphQL::Types::Relay::HasNodeField
        include ::GraphQL::Types::Relay::HasNodesField

        field :tracking_info, resolver: ::Transponder::GraphQL::Queries::Tracking
        field :document, resolver: ::Transponder::GraphQL::Queries::Document
        field :fetch_rates, resolver: ::Transponder::GraphQL::Queries::Rates
        field :fetch_pro, resolver: ::Transponder::GraphQL::Queries::FetchPro

        multiple_fields ::Transponder::GraphQL::Queries::Carrier
      end
    end
  end
end
