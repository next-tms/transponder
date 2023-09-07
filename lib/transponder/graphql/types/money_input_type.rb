# frozen_string_literal: true

require 'money'

module Transponder
  module GraphQL
    module Types
      class MoneyInputType < ::GraphQL::Schema::InputObject
        argument :currency, ISO4217Type, required: true
        argument :fractional, Integer, required: true

        def prepare
          Money.from_cents(fractional, currency)
        end
      end
    end
  end
end
