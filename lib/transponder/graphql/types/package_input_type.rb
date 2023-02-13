# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class PackageInputType < ::GraphQL::Schema::InputObject
        argument :total_grams_or_ounces, Float, required: false
        argument :dimensions, Types::DimensionInputType, required: false
        argument :packaging_type, String, required: false
        argument :options, ::GraphQL::Types::JSON, required: false
      end
    end
  end
end
