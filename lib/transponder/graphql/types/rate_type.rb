module Transponder
  module GraphQL
    module Types
      class RateType < BaseObject
        field :costs, [RateBreakdownType], null: true
        field :estimate_reference, String, null: true
        field :expires_at, ::GraphQL::Types::ISO8601DateTime, null: true
        field :service_name, String, null: true
        field :shipping_carrier, GenericCarrierType, null: false
        field :total_cost, MoneyType, null: false
        field :transit_days, Integer, null: true
        field :with_excessive_length_fees, Boolean, null: true

        def shipping_carrier
          {
            name: object.carrier_name,
            scac: object.scac
          }
        end

        def costs
          object.prices.map { |price| { cost: { currency: object.currency, fractional: price.cents }, description: price.description } }
        end

        def total_cost
          {
            currency: object.currency,
            fractional: object.total_cents
          }
        end
      end
    end
  end
end
