module Transponder
  module GraphQL
    module Types
      class LaneType < BaseObject
        field :destination, TerritoryType, null: false
        field :id, ID, null: false, description: 'Permanent UUID'
        field :origin, TerritoryType, null: false
      end
    end
  end
end
