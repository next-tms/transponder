# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class TerminalType < BaseObject
        field :address, CarrierAddressType, null: false
        field :id, ID, null: false
        field :phone, String, null: true, description: 'E.164 phone number'
      end
    end
  end
end
