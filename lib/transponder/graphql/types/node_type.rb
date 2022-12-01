# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      module NodeType
        include Types::BaseInterface
        # Add the `id` field
        include ::GraphQL::Types::Relay::NodeBehaviors
      end
    end
  end
end
