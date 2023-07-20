# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class DimensionInputType < ::GraphQL::Schema::InputObject
        argument :length, Float, required: false
        argument :width, Float, required: false
        argument :height, Float, required: false
      end
    end
  end
end
