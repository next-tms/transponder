# frozen_string_literal: true

module Transponder
  module FreightKitClient
    class BuildClient
      class CarrierNotImplmentedError < NotImplementedError; end

      def initialize(credentials:, customer_location:, scac:, tariff: nil)
        @credentials = credentials
        @customer_location = customer_location
        @scac = scac
        @tariff = tariff
      end

      def call
        carrier = ::FreightKit::Carriers.all.find { |carrier| carrier.scac&.downcase == scac.to_s.downcase }
        raise CarrierNotImplmentedError, 'Carrier not supported' unless carrier

        # @note FreightKit validates that tariff is a FreightKit::Tariff when it's present
        kwargs = { customer_location: freight_kit_customer_location }
        kwargs[:tariff] = freight_kit_tariff if freight_kit_tariff.present?

        carrier.new(freight_kit_credentials, **kwargs)
      end

      private

      attr_reader :credentials, :customer_location, :scac, :tariff

      def freight_kit_credentials
        credentials.map { |credential| BuildCredentials.new(credentials: credential).call }
      end

      def freight_kit_customer_location
        attributes = customer_location.to_hash.except(:country_code)
        attributes[:contact] = ::FreightKit::Contact.new(**customer_location[:contact])
        attributes[:country] = ActiveUtils::Country.find(customer_location[:country_code])

        ::FreightKit::Location.new(**attributes)
      end

      def freight_kit_tariff
        return if tariff.blank?

        @freight_kit_tariff ||= BuildTariff.new(tariff:).call
      end
    end
  end
end
