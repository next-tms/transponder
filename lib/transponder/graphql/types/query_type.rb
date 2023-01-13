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

        field :carrier, CarrierType, null: true do
          argument :scac, String, required: true
        end

        field :carriers, [CarrierType], null: false

        def carrier(scac:)
          ::Interstellar::Carriers.all.find { |carrier| carrier.scac&.downcase == scac.to_s.downcase }
        end

        def carriers
          @carriers ||= ::Interstellar::Carriers.all
        end
      end
    end
  end
end
