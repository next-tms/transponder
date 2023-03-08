# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class LocationInputType < ::GraphQL::Schema::InputObject
        argument :address1, String, required: false
        argument :city, String, required: false
        argument :country_code, String, required: false
        argument :postal_code, String, required: false
        argument :province, String, required: false
        argument :contact, ContactInputType, required: false
      end
    end
  end
end
