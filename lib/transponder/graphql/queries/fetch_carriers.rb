# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class FetchCarriers < ::GraphQL::Schema::Resolver
        type [::Transponder::GraphQL::Types::CarrierType], null: false

        def resolve
          @carriers ||= ::FreightKit::Carriers.all
        end
      end
    end
  end
end
