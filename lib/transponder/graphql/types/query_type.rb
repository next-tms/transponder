# frozen_string_literal: true

require 'freight_kit'
require 'freight_kit-next'

module Transponder
  module GraphQL
    module Types
      class QueryType < BaseObject
        # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
        include ::GraphQL::Types::Relay::HasNodeField
        include ::GraphQL::Types::Relay::HasNodesField

        field :fetch_document, resolver: ::Transponder::GraphQL::Queries::FetchDocument
        field :fetch_pro, resolver: ::Transponder::GraphQL::Queries::FetchPro
        field :fetch_rates, resolver: ::Transponder::GraphQL::Queries::FetchRates
        field :fetch_tracking, resolver: ::Transponder::GraphQL::Queries::FetchTracking

        multiple_fields ::Transponder::GraphQL::Queries::Carrier
      end
    end
  end
end
