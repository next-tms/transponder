# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class MutationType < BaseObject
        field :create_pickup, resolver: ::Transponder::GraphQL::Mutations::CreatePickup
      end
    end
  end
end
