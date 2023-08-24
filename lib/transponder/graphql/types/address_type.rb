# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class AddressType < BaseObject
        field :city, String, null: false
        field :country, CountryType, null: false
        field :postal_code, String, null: false
        field :region_abbreviation, String, null: false
        field :street, String
        field :street2, String
      end
    end
  end
end
