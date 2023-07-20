# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class PackagingType < BaseEnum
        value "BOX", value: :box
        value "BUNDLE", value: :bundle
        value "CONTAINER", "Shipping container", value: :container
        value "CRATE", value: :crate
        value "CYLINDER", value: :cylinder
        value "DRUM", value: :luggage
        value "LUGGAGE", value: :luggage
        value "PAIL", value: :pail
        value "PALLET", value: :pallet
        value "PIECE", value: :piece
        value "ROLL", value: :roll
        value "TOTE", value: :tote
        value "TRUCKLOAD", value: :truckload
      end
    end
  end
end
