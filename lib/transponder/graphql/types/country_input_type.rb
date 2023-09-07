# frozen_string_literal: true

require 'active_utils'

module Transponder
  module GraphQL
    module Types
      class CountryInputType < ::GraphQL::Schema::InputObject
        argument :alpha2, ISO31661Alpha2Type, required: false
        argument :alpha3, ISO31661Alpha3Type, required: false

        def prepare
          ActiveUtils::Country.find(alpha3.presence || alpha)
        end
      end
    end
  end
end
