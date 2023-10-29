# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class CustomerLocationInputType < ::GraphQL::Schema::InputObject
        argument :address1, String, required: true
        argument :city, String, required: true
        argument :contact, ContactInputType, required: true
        argument :country, CountryInputType, required: true
        argument :postal_code, String, required: true
        argument :region_abbreviation, String, required: true

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
