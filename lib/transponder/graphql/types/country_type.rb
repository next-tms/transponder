# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class CountryType < BaseObject
        field :alpha2, Types::ISO31661Alpha2Type, null: false
        field :alpha3, Types::ISO31661Alpha3Type, null: false
        field :name, String, null: false
        field :numeric, Integer, null: true
        field :regions, [Types::RegionType], null: false

        class << self
          # `FreightKit::Country#regions` scans every region, so group them once per locale (names are localized).
          def regions_by_country = (@regions ||= {})[I18n.locale] ||= ::FreightKit::Regions.all.group_by(&:country)
        end

        # @note `object` is a `FreightKit::Country` from `fetchCountries`, or an
        #   `ActiveUtils::Country` from carrier responses (`AddressType`, `LocationType`).
        def alpha2 = freight_kit_country? ? object.iso31661_alpha2 : object.code(:alpha2).value

        def alpha3 = freight_kit_country? ? object.iso31661_alpha3 : object.code(:alpha3).value

        def numeric = freight_kit_country? ? object.un_code : country&.un_code || object.code(:numeric)&.value&.to_i

        def regions = self.class.regions_by_country.fetch(country, [])

        private

        def country = freight_kit_country? ? object : ::FreightKit::Countries.find_by(iso31661_alpha2: alpha2)

        def freight_kit_country? = object.is_a?(::FreightKit::Country)
      end
    end
  end
end
