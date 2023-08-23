# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class FreightKitLocationType < BaseObject
        field :city, String, null: true
        field :country, Types::FreightKitCountryType
        field :province, String, null: true
        field :time_zone, String, null: true
      end
    end
  end
end
