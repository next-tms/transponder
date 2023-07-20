# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class CarrierType < BaseObject
        field :bol_requires_tracking_number, Boolean, null: false
        def bol_requires_tracking_number
          object.bol_requires_tracking_number?
        end

        field :maximum_height, LengthType, null: false
        field :maximum_weight, WeightType, null: false
        field :minimum_length_for_overlength_fees, LengthType, null: false
        field :name, String, null: true

        field :quote_declared_value, Boolean, null: false
        def quote_declared_value
          object.find_rates_with_declared_value?
        end

        field :quote_overlength_with_tariff, Boolean, null: false
        def quote_overlength_with_tariff
          object.overlength_fees_require_tariff?
        end

        field :scac, String, null: true
      end
    end
  end
end
