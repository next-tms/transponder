# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class FetchCountries < ::GraphQL::Schema::Resolver
        type [::Transponder::GraphQL::Types::CountryType], null: false

        argument :alpha2, [::Transponder::GraphQL::Types::ISO31661Alpha2Type], required: false

        def resolve(alpha2: nil)
          countries = ::FreightKit::Countries.all
          return countries if alpha2.nil?

          countries.select { |country| alpha2.include?(country.iso31661_alpha2) }
        end
      end
    end
  end
end
