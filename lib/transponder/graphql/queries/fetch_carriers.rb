module Transponder
  module GraphQL
    module Queries
      class FetchCarriers < ::GraphQL::Schema::Resolver
        type [::Transponder::GraphQL::Types::CarrierType], null: false

        argument :ids, [ID], required: false

        def resolve(ids: nil)
          carriers = ::FreightKit::Carriers.all
          return carriers if ids.nil?

          carriers.select { |carrier| ids.include?(carrier.id) }
        end
      end
    end
  end
end
