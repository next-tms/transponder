# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class OverlengthRuleInputType < ::GraphQL::Schema::InputObject
        argument :cost, MoneyInputType, required: true
        argument :maximum_length, LengthInputType, required: false
        argument :minimum_length, LengthInputType, required: true

        def prepare
          { fee_cents: cost.fractional, max_length: maximum_length, min_length: minimum_length }
        end
      end
    end
  end
end
