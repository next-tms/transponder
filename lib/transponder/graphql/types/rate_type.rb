# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class RateType < BaseObject
        field :total_cents, Float, null: false
        field :currency, String, null: false
        field :estimate_reference, String, null: true
        field :carrier_name, String, null: true
        field :with_excessive_length_fees, Boolean, null: true
        field :transit_days, Integer, null: true
        field :prices, [RateBreakdownType], null: true
        field :expires_at, ::GraphQL::Types::ISO8601DateTime, null: true
      end
    end
  end
end
