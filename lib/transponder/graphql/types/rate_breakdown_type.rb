# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class RateBreakdownType < BaseObject
        field :cents, MoneyType, null: true
        field :description, String, null: true
      end
    end
  end
end
