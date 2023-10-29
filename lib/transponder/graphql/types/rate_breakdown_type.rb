# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class RateBreakdownType < BaseObject
        field :blame, String, null: true
        field :cost, MoneyType, null: true
        field :description, String, null: true
      end
    end
  end
end
