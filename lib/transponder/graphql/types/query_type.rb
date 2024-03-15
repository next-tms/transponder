# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class QueryType < BaseObject
        # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
        include ::GraphQL::Types::Relay::HasNodeField
        include ::GraphQL::Types::Relay::HasNodesField

        field :fetch_carrier, resolver: ::Transponder::GraphQL::Queries::FetchCarrier
        field :fetch_carriers, resolver: ::Transponder::GraphQL::Queries::FetchCarriers
        field :fetch_document, resolver: ::Transponder::GraphQL::Queries::FetchDocument
        field :fetch_pro, resolver: ::Transponder::GraphQL::Queries::FetchPro
        field :fetch_rates, resolver: ::Transponder::GraphQL::Queries::FetchRates
        field :fetch_tracking, resolver: ::Transponder::GraphQL::Queries::FetchTracking
      end
    end
  end
end
