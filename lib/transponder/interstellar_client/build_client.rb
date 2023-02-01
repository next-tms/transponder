module Transponder
  module InterstellarClient
    class BuildClient
      def initialize(scac:, credentials:)
        @scac = scac
        @credentials = credentials
      end

      def call
        carrier = ::Interstellar::Carriers.all.find { |carrier| carrier.scac&.downcase == scac.to_s.downcase }
        return nil unless carrier

        interstellar_credentials = BuildCredentials.new(credentials: credentials).call
        carrier.new(interstellar_credentials, customer_location: customer_location)
      end

      private

      attr_reader :scac, :credentials

      def customer_location
        # CAVEAT: Static for now. Planning to have a Broker Table that will store the customer
        # location data. And will use that table to have authentication in the GraphQL API
        ::Interstellar::Location.new(
          country: ActiveUtils::Country.find('US'),
          province: 'CA',
          city: 'Los Angeles',
          postal_code: '90046',
          address1: '7200 Franklin Ave Ste 219'
        )
      end
    end
  end
end