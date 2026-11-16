module Transponder
  module GraphQL
    module Types
      # @note A blank attribute matches any location.
      class TerritoryType < BaseObject
        field :country, Types::CountryType, null: false
        field :postal_codes, [String], null: false, description: 'Postal codes or their prefixes (e.g. "850")'
        field :region_abbreviation, String, null: true
      end
    end
  end
end
