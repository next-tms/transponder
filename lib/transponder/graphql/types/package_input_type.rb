# frozen_string_literal: true

require 'freight_kit'

module Transponder
  module GraphQL
    module Types
      class PackageInputType < ::GraphQL::Schema::InputObject
        argument :description, String, required: false
        argument :dimensions, Types::DimensionInputType, required: false
        argument :freight_class, Types::FreightClassType, required: false
        argument :hazardous, ::GraphQL::Types::Boolean, required: true
        argument :nmfc, String, required: false
        argument :packaging, Types::PackagingType, required: true
        argument :weight, WeightInputType, required: true

        def prepare
          dimensions ||= { height: 0, length: 0, width: 0 }

          options = {}.tap do |builder|
            builder[:declared_freight_class] = declared_freight_class if declared_freight_class.present?
            builder[:description] = description if description.present?
            builder[:hazmat] = hazardous
            builder[:nmfc] = nmfc if nmfc.present?
            builder[:quantity] = 1
            builder[:type] = packaging
            builder[:units] = :imperial
          end

          FreightKit::Package.new(weight.convert_to(:oz).value, dimensions, packaging.to_sym, options)
        end

        private

        def declared_freight_class
          @declared_freight_class ||= if freight_class.present?
                                        value = freight_class.delete_prefix('_').gsub('_', '.')
                                        value.include?('.') ? value.to_f : value.to_i
                                      end
        end
      end
    end
  end
end
