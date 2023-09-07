# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class LocationType < BaseObject
        field :city, String, null: true
        field :country, Types::CountryType
        field :region_abbreviation, String, null: true, method: :province
        field :time_zone, String, null: true
      end
    end
  end
end
