# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class TariffInputType < ::GraphQL::Schema::InputObject
        argument :overlength_rules, [OverlengthRuleInputType], required: true
      end
    end
  end
end
