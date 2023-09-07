# frozen_string_literal: true

require 'measured'

module Transponder
  module GraphQL
    module Types
      class WeightInputType < ::GraphQL::Schema::InputObject
        argument :amount, Float, required: true
        argument :unit, WeightUnitCategory, required: true

        def prepare
          ::Measured::Weight.new(amount, unit)
        end
      end
    end
  end
end
