# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class BaseUnion < ::GraphQL::Schema::Union
        edge_type_class(BaseEdge)
        connection_type_class(BaseConnection)
      end
    end
  end
end
