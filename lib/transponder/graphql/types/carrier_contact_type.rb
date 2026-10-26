module Transponder
  module GraphQL
    module Types
      class CarrierContactType < BaseObject
        field :company_name, String, null: true
        field :department, String, null: true
        field :email, String, null: true
        field :fax, String, null: true
        field :id, ID, null: false
        field :name, String, null: true
        field :phone, String, null: true, description: 'E.164 phone number'
      end
    end
  end
end
