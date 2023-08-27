# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class TariffType < BaseObject
        field :overlength_rules, [OverlengthRuleType], null: false
      end
    end
  end
end
