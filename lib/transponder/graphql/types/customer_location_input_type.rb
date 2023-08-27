# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class CustomerLocationInputType < ::GraphQL::Schema::InputObject
        argument :address1, String, required: true
        argument :city, String, required: true
        argument :contact, ContactInputType, required: true
        argument :country_code, String, required: true
        argument :postal_code, String, required: true
        argument :province, String, required: true
      end
    end
  end
end
