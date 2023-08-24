# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class FreightKitCountryType < BaseObject
        field :alpha2, Types::ISO31661Alpha2Type, null: false

        field :name, String

        field :alpha3, Types::ISO31661Alpha3Type, null: false
        field :numeric, String, null: true

        def alpha2
          object.code(:alpha2).value
        end

        def alpha3
          object.code(:alpha3).value
        end

        def numeric
          object.code(:numeric).value
        end
      end
    end
  end
end
