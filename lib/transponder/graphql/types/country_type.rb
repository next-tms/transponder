# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class CountryType < BaseObject
        field :alpha2_code, Types::ISO31661Alpha2Type, null: false
        field :alpha3_code, Types::ISO31661Alpha2Type, null: false
        field :name, String, null: true
        field :un_code, Types::ISO31661Alpha2Type, null: false
      end
    end
  end
end
