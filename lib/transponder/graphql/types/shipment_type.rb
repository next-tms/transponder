# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class ShipmentType < BaseObject
        field :destination, AddressType, null: false
        field :origin, AddressType, null: false

        field :accessorials, [AccessorialCategory], null: false
        field :packages, [PackageType], null: false
      end
    end
  end
end
