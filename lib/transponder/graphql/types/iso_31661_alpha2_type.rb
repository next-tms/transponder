# frozen_string_literal: true

require 'active_utils'

module Transponder
  module GraphQL
    module Types
      class ISO31661Alpha2Type < BaseEnum
        description "See https://www.rubydoc.info/gems/active_utils/#{ActiveUtils::VERSION}/ActiveUtils/Country"

        ActiveUtils::Country::COUNTRIES.map { |country| country[:alpha2] }.uniq.sort.map do |alpha2|
          description = ActiveUtils::Country::COUNTRIES
                        .select { |country| country[:alpha2] == alpha2 }
                        .map { |country| country[:name] }
                        .join(', ')

          value alpha2, description:
        end
      end
    end
  end
end
