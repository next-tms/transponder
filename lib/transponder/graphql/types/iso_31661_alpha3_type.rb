require 'active_utils'
require 'freight_kit'

module Transponder
  module GraphQL
    module Types
      class ISO31661Alpha3Type < BaseEnum
        description "See https://www.rubydoc.info/gems/active_utils/#{ActiveUtils::VERSION}/ActiveUtils/Country"

        # @note `ActiveUtils` still uses retired codes (e.g. `ROM` for Romania), so the
        #   current ISO codes from `FreightKit::Countries` are added alongside them.
        countries = ActiveUtils::Country::COUNTRIES +
                    FreightKit::Countries.all.map { |country| { alpha3: country.iso31661_alpha3, name: country.name } }

        countries.map { |country| country[:alpha3] }.uniq.sort.map do |alpha3|
          description = countries.select { |country| country[:alpha3] == alpha3 }.map { |country| country[:name] }.uniq.join(', ')

          value alpha3, description:
        end
      end
    end
  end
end
