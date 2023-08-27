# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class OverlengthRuleInputType < ::GraphQL::Schema::InputObject
        argument :cost, MoneyInputType, required: true
        argument :maximum_length, LengthInputType, required: false
        argument :minimum_length, LengthInputType, required: true
      end
    end
  end
end
