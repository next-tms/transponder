# frozen_string_literal: true

require 'measured'

module Transponder
  module GraphQL
    module Types
      class LengthInputType < ::GraphQL::Schema::InputObject
        argument :amount, Float, required: true
        argument :unit, LengthUnitCategory, required: true

        def prepare
          ::Measured::Length.new(amount, unit)
        end
      end
    end
  end
end
