# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class PackageInputType < ::GraphQL::Schema::InputObject
        argument :dimensions, Types::DimensionInputType, required: false
        argument :options, ::GraphQL::Types::JSON, required: false
        argument :packaging_type, String, required: false
        argument :total_grams_or_ounces, Float, required: false
      end
    end
  end
end
