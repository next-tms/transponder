# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class WeightType < BaseObject
        field :g, Float, null: false
        field :lb, Float, null: false
        field :kg, Float, null: false
        field :oz, Float, null: false

        def g
          object.convert_to(:g).value
        end

        def kg
          object.convert_to(:kg).value
        end

        def lb
          object.convert_to(:lb).value
        end

        def oz
          object.convert_to(:oz).value
        end
      end
    end
  end
end
