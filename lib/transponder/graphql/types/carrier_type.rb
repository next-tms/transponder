# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class CarrierType < BaseObject
        field :bol_requires_tracking_number, Boolean, null: false, method: :bol_requires_tracking_number?
        field :maximum_height, LengthType, null: false
        field :maximum_weight, WeightType, null: false
        field :minimum_length_for_overlength_fees, LengthType, null: false
        field :name, String, null: true
        field :quote_declared_value, Boolean, null: false, method: :find_rates_with_declared_value?
        field :quote_overlength_with_tariff, Boolean, null: false, method: :overlength_fees_require_tariff?
        field :scac, String, null: true
      end
    end
  end
end
