# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class FetchCarrier < ::GraphQL::Schema::Resolver
        type ::Transponder::GraphQL::Types::CarrierType, null: true

        argument :scac, String, required: true

        def resolve(scac:)
          ::FreightKit::Carriers.all.find { |carrier| carrier.scac&.upcase == scac.upcase }
        end
      end
    end
  end
end
