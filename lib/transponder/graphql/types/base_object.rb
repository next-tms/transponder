# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class BaseObject < ::GraphQL::Schema::Object
        edge_type_class(BaseEdge)
        connection_type_class(BaseConnection)
        field_class BaseField
      end
    end
  end
end
