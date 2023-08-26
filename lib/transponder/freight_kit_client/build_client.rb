# frozen_string_literal: true

module Transponder
  module FreightKitClient
    class BuildClient
      class UnknownSCACError < StandardError
        def initialize(scac)
          super("No API exists for carrier with SCAC \"#{scac}\"")
        end
      end

      def initialize(scac:, credentials:)
        @scac = scac
        @credentials = credentials
      end

      def call
        carrier = ::FreightKit::Carriers.all.find { |carrier| carrier.scac&.downcase == scac.to_s.downcase }
        raise UnknownSCACError, scac unless carrier

        freight_kit_credentials = credentials.map { |credential| BuildCredentials.new(credentials: credential).call }
        carrier.new(freight_kit_credentials, customer_location: customer_location)
      end

      private

      attr_reader :scac, :credentials

      # @note Static for now. Planning to have a Broker Table that will store the customer location data. And will use
      # that table to have authentication in the GraphQL API
      # @todo Use address supplied by client
      def customer_location
        ::FreightKit::Location.new(
          country: ActiveUtils::Country.find('US'),
          province: 'CA',
          city: 'Los Angeles',
          postal_code: '90046',
          address1: '7200 Franklin Ave Ste 219',
        )
      end
    end
  end
end
