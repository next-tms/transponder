# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class CarrierCredentialType < BaseObject
        field :account, String
        field :username, String, null: false
        field :password, String, null: false

        field :type, CarrierCredentialCategory, null: false
      end
    end
  end
end
