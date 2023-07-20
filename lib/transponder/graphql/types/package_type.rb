# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class PackageType < BaseObject
        field :quantity, Integer, null: false
        field :packaging, PackagingType, null: false

        field :height, LengthType, null: false
        field :length, LengthType, null: false
        field :width, LengthType, null: false

        field :weight, WeightType, null: false

        field :freight_class, String
        field :nmfc, String
      end
    end
  end
end
