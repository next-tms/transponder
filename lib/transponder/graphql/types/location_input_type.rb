# frozen_string_literal: true

require 'freight_kit'

module Transponder
  module GraphQL
    module Types
      class LocationInputType < ::GraphQL::Schema::InputObject
        argument :address1, String, required: false
        argument :city, String, required: false
        argument :contact, ContactInputType, required: false
        argument :country, CountryInputType, required: true
        argument :postal_code, String, required: false
        argument :region_abbreviation, String, required: false

        def prepare
          FreightKit::Location.new(
            address1:,
            city:,
            contact:,
            country:,
            postal_code:,
            province: region_abbreviation,
          )
        end
      end
    end
  end
end
