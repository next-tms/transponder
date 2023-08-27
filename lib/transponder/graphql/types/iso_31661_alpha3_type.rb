# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class ISO31661Alpha3Type < BaseEnum
        ActiveUtils::Country::COUNTRIES.map { |country| country[:alpha3] }.uniq.sort.map do |alpha3|
          description = ActiveUtils::Country::COUNTRIES
                        .select { |country| country[:alpha3] == alpha3 }
                        .map { |country| country[:name] }
                        .join(', ')

          value alpha3, description:
        end
      end
    end
  end
end
