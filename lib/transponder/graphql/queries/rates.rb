module Transponder
  module GraphQL
    module Queries
      class Rates < Transponder::GraphQL::Types::BaseInterstellarResolver
        require 'active_utils'

        type ::Transponder::GraphQL::Types::RateResponseType, null: true
        
        argument :accessorials, [String], required: false
        argument :value_scents, Float, required: false
        argument :packages, [Transponder::GraphQL::Types::PackageInputType], required: true
        argument :origin, Transponder::GraphQL::Types::LocationInputType, required: false
        argument :destination, Transponder::GraphQL::Types::LocationInputType, required: false
        argument :pickup_at, ::GraphQL::Types::ISO8601DateTime, required: false

        def call(**args)
          shipment = Interstellar::Shipment.new(
            accessorials: args[:accessorials] || [],
            declared_value_cents: args[:value_cents],
            origin: to_interstellar_shipping_address(args[:origin].to_h),
            destination: to_interstellar_shipping_address(args[:destination].to_h),
            packages: args[:packages].map { |package| to_interstellar_pacakage(package.to_h) },
            pickup_at: iso8601_to_datetime_with_timezone(args[:pickup_at])
          )

          Hanami.logger.debug(shipment.inspect)

          response = interstellar_client.find_rates(shipment: shipment)
          Hanami.logger.debug(response.inspect)
          response
        end

        def to_interstellar_shipping_address(address)
          Interstellar::Location.new(
            **address.except(:country_code),
            country: ActiveUtils::Country.find(address[:country_code])
          )
        end

        def iso8601_to_datetime_with_timezone(iso8601)
          timezone_offset = iso8601.to_datetime.offset.numerator
          tz = ActiveSupport::TimeZone[timezone_offset]

          iso8601.to_datetime.in_time_zone(tz)          
        end

        def to_interstellar_pacakage(package)
          package[:options] ||= {}
          Interstellar::Package.new(
            package[:total_grams_or_ounces],
            package[:dimensions].to_h,
            package[:packaging_type].to_sym,
            **package[:options]
          )
        end
      end
    end
  end
end
