module Transponder
  module GraphQL
    module Types
      class CountryType < BaseObject
        class << self
          # `FreightKit::Country#regions` scans every region, so group them once per locale (names are localized).
          def regions_by_country = (@regions ||= {})[I18n.locale] ||= ::FreightKit::Regions.all.group_by(&:country)
        end

        POSTAL_CODE_LABELS = {
          'AT' => 'PLZ',
          'BR' => 'CEP',
          'CH' => 'PLZ',
          'DE' => 'PLZ',
          'GB' => 'Postcode',
          'IE' => 'Eircode',
          'IN' => 'PIN',
          'IT' => 'CAP',
          'US' => 'ZIP'
        }.freeze

        field :alpha2, Types::ISO31661Alpha2Type, null: false
        field :alpha3, Types::ISO31661Alpha3Type, null: false
        field :name, String, null: false
        field :numeric, Integer, null: true
        field :postal_code, Boolean, null: false, description: 'Whether the country uses postal codes.'
        field :postal_code_format,
              String,
              null: true,
              description: 'An unanchored regular expression for valid postal codes, usable as an HTML `pattern`.'
        field :postal_code_label, String, null: false, description: 'The local name for a postal code, such as "ZIP".'
        field :regions, [Types::RegionType], null: false

        # @note `object` is a `FreightKit::Country` from `fetchCountries`, or an
        #   `ActiveUtils::Country` from carrier responses (`AddressType`, `LocationType`).
        def alpha2 = freight_kit_country? ? object.iso31661_alpha2 : object.code(:alpha2).value

        def alpha3 = freight_kit_country? ? object.iso31661_alpha3 : object.code(:alpha3).value
        def numeric = freight_kit_country? ? object.un_code : country&.un_code || object.code(:numeric)&.value&.to_i
        def postal_code = iso_country&.postal_code || false

        # `ISO3166::Country#postal_code_format` wraps the format in Ruby-only `\A`/`\Z` anchors, so read the raw value.
        def postal_code_format = (iso_country.data['postal_code_format'] if postal_code)

        def postal_code_label = POSTAL_CODE_LABELS.fetch(alpha2, 'Postal code')
        def regions = self.class.regions_by_country.fetch(country, [])

        private

        def country = freight_kit_country? ? object : ::FreightKit::Countries.find_by(iso31661_alpha2: alpha2)
        def freight_kit_country? = object.is_a?(::FreightKit::Country)
        def iso_country = ISO3166::Country[alpha2]
      end
    end
  end
end
