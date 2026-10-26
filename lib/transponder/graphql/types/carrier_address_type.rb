module Transponder
  module GraphQL
    module Types
      # @note `object` is a `FreightKit::Address` from carrier data, which can be incomplete, unlike `AddressType`.
      class CarrierAddressType < BaseObject
        field :city, String, null: true
        field :country, CountryType, null: true
        field :id, ID, null: false
        field :postal_code, String, null: true
        field :region_abbreviation, String, null: true
        field :street, String, null: true
        field :street2, String, null: true
      end
    end
  end
end
