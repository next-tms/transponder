module Transponder
  module GraphQL
    module Queries
      class FetchCountries < ::GraphQL::Schema::Resolver
        type [::Transponder::GraphQL::Types::CountryType], null: false

        argument :alpha2, [::Transponder::GraphQL::Types::ISO31661Alpha2Type], required: false
        argument :name, String, required: false, description: 'A free-text country name or ISO 3166-1 code, ' \
                                                              'such as "United States", "USA" or "us".'

        def resolve(alpha2: nil, name: nil)
          countries = ::FreightKit::Countries.all
          countries = countries.select { |country| alpha2.include?(country.iso31661_alpha2) } unless alpha2.nil?
          countries &= Array(find_by_name(name.strip)) unless name.nil?
          countries
        end

        private

        # `find_country_by_any_name` matches names, unofficial names and translations, but not codes such as "US".
        def find_by_name(name) = find_by_code(name.upcase) || find_by_iso_name(name)

        def find_by_code(code)
          ::FreightKit::Countries.all.find { |country| [country.iso31661_alpha2, country.iso31661_alpha3].include?(code) }
        end

        def find_by_iso_name(name)
          alpha2 = ISO3166::Country.find_country_by_any_name(name)&.alpha2
          ::FreightKit::Countries.find_by(iso31661_alpha2: alpha2) if alpha2
        end
      end
    end
  end
end
