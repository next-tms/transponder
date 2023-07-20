# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class MoneyType < BaseObject
        # Duck Typing Money Object from money-rails gem
        field :value, Float, null: true
        def value
          object
        end

        field :currency, String, null: true

        def currency
          object.try(:currency) || 'USD'
        end
      end
    end
  end
end
