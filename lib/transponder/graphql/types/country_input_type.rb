# frozen_string_literal: true

require 'active_utils'
require 'freight_kit'

module Transponder
  module GraphQL
    module Types
      class CountryInputType < ::GraphQL::Schema::InputObject
        argument :alpha2, ISO31661Alpha2Type, required: false
        argument :alpha3, ISO31661Alpha3Type, required: false

        def prepare = ActiveUtils::Country.find(alpha3.present? ? active_utils_code : alpha2)

        private

        # @note `ActiveUtils` still uses retired codes (e.g. `ROM` for Romania), so a current
        #   ISO code from `FreightKit::Countries` is looked up by its alpha-2 code instead.
        def active_utils_code = ::FreightKit::Countries.find_by(iso31661_alpha3: alpha3)&.iso31661_alpha2 || alpha3
      end
    end
  end
end
