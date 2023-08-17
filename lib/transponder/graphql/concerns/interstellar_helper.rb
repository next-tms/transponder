module Transponder
  module GraphQL
    module Concerns
      module InterstellarHelper
        require 'active_utils'

        def build_interstellar_contact(args)
          args = args[:contact] if args[:contact]

          params = {
            company_name: args[:company_name],
            email: args[:email],
            name: args[:name],
            phone: args[:phone]
          }.compact

          Interstellar::Contact.new(**params)
        end

        def build_interstellar_shipment(args)
          params = {
            accessorials: args[:accessorials]&.map(&:to_sym) || [],
            declared_value_cents: args[:value_cents],
            origin: to_interstellar_shipping_address(args[:origin].to_h),
            destination: to_interstellar_shipping_address(args[:destination].to_h),
            packages: args[:packages].map { |package| to_interstellar_pacakage(package.to_h) },
            po_number: args[:po_number],
            order_number: args[:order_number],
            pro: args[:pro],
          }.compact

          params[:pickup_at] = iso8601_to_datetime_with_timezone(args[:pickup_at]) if args[:pickup_at]

          Interstellar::Shipment.new(**params)
        end

        def to_interstellar_shipping_address(address)
          return unless address

          contact_args = address.extract!(:contact)

          location = Interstellar::Location.new(
            **address.except(:country_code),
            country: ActiveUtils::Country.find(address[:country_code])
          )
          
          location.contact = build_interstellar_contact(contact_args) if contact_args.present?

          location
        end

        def iso8601_to_datetime_with_timezone(iso8601)
          return unless iso8601

          timezone_offset = iso8601.to_datetime.offset.numerator
          tz = ActiveSupport::TimeZone[timezone_offset]

          iso8601.to_datetime.in_time_zone(tz)          
        end

        def to_interstellar_pacakage(package)
          package[:options] ||= {}
          package[:options]['units'] = package[:options]['units']&.to_sym

          Hanami.logger.debug("------#{package.inspect}")
          Interstellar::Package.new(
            package[:total_grams_or_ounces],
            package[:dimensions].to_h,
            package[:packaging_type].to_sym,
            **package[:options].transform_keys(&:underscore).deep_symbolize_keys
          )
        end  
      end
    end
  end
end
