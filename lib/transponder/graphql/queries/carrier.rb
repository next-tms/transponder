# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class Carrier < ::Transponder::GraphQL::Types::BaseObject
        field :carrier, ::Transponder::GraphQL::Types::CarrierType, null: true do
          argument :scac, String, required: true
        end

        field :carriers, [::Transponder::GraphQL::Types::CarrierType], null: false

        ::Transponder::GraphQL::Types::QueryType.class_eval do
          def carrier(scac:)
            ::FreightKit::Carriers.all.find { |carrier| carrier.scac&.downcase == scac.to_s.downcase }
          end

          def carriers
            @carriers ||= ::FreightKit::Carriers.all
          end
        end
      end
    end
  end
end
