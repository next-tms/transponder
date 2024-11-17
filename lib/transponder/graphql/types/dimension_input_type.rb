# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class DimensionInputType < ::GraphQL::Schema::InputObject
        argument :height, LengthInputType, required: false
        argument :length, LengthInputType, required: false
        argument :width, LengthInputType, required: false

        def prepare
          {
            height: height || 0,
            length: length || 0,
            width: width || 0
          }
        end
      end
    end
  end
end
