# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class GenericCarrierType < BaseObject
        field :name, String, null: true
        field :scac, String, null: true
      end
    end
  end
end
