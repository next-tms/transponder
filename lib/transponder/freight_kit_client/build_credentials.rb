# frozen_string_literal: true

module Transponder
  module FreightKitClient
    class BuildCredentials
      def initialize(credentials:)
        @type = credentials[:type]
        @credentials = credentials
      end

      def call
        return nil if [:api, :api_key, :api_proxy, :selenoid, :website].exclude?(type)
        return selenoid_credentials if type == :selenoid

        FreightKit::Credential.new(**credentials)
      end

      private

      attr_reader :type, :credentials

      def selenoid_credentials
        FreightKit::Credential.new(
          type: :selenoid,
          base_url: URI.parse(ENV.fetch("SELENOID_BASE_URL")),
          browser: :chrome,
        )
      end
    end
  end
end
