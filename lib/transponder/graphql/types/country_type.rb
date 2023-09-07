# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class CountryType < BaseObject
        field :alpha2, Types::ISO31661Alpha2Type, null: false
        field :alpha3, Types::ISO31661Alpha3Type, null: false
        field :name, String, null: false

        def alpha2
          object.code(:alpha2).value
        end

        def alpha3
          object.code(:alpha3).value
        end
      end
    end
  end
end
