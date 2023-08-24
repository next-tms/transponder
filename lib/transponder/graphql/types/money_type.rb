# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class MoneyType < BaseObject
        field :currency, String, null: true
        field :value, Float, null: true # duck typing Money object from money-rails gem

        def value
          object
        end

        def currency
          object.try(:currency) || 'USD'
        end
      end
    end
  end
end
