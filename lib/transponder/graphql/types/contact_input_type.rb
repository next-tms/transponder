# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class ContactInputType < ::GraphQL::Schema::InputObject
        argument :company_name, String, required: false
        argument :email, String, required: false
        argument :name, String, required: false
        argument :phone, String, required: false
      end
    end
  end
end
