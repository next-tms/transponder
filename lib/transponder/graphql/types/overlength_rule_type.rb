# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class OverlengthRuleType < BaseObject
        field :cost, MoneyType, null: false
        field :maximum_length, LengthType, null: true
        field :minimum_length, LengthType, null: false
      end
    end
  end
end
