module Transponder
  module GraphQL
    module Types
      class RegionType < BaseObject
        field :abbreviation, String, null: false
        field :iso31662, String, null: false
        field :name, String, null: false
      end
    end
  end
end
