# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class MoneyType < BaseObject
        field :currency, ISO4217Type, null: false
        field :fractional, Integer, null: false
      end
    end
  end
end
