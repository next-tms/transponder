# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class MoneyInputType < ::GraphQL::Schema::InputObject
        argument :currency, ISO4217InputType, required: true
        argument :fractional, Integer, required: true
      end
    end
  end
end
