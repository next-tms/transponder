# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class RateType < BaseObject
        field :carrier_name, String, null: true
        field :currency, String, null: false
        field :estimate_reference, String, null: true
        field :expires_at, ::GraphQL::Types::ISO8601DateTime, null: true
        field :prices, [RateBreakdownType], null: true
        field :scac, String, null: true
        field :service_name, String, null: true
        field :total_cents, MoneyType, null: false
        field :transit_days, Integer, null: true
        field :with_excessive_length_fees, Boolean, null: true
      end
    end
  end
end
