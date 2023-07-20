# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class WeightType < BaseObject
        field :lb, Float, null: false
        def lb
          object.convert_to(:lb).value
        end

        field :g, Float, null: false
        def g
          object.convert_to(:g).value
        end

        field :kg, Float, null: false
        def kg
          object.convert_to(:kg).value
        end

        field :oz, Float, null: false
        def oz
          object.convert_to(:oz).value
        end
      end
    end
  end
end
