module Transponder
    module InterstellarClient
    class BuildCredentials
      def initialize(credentials:)
        @type = credentials[:type]
        @credentials = credentials
      end

      def call
        return nil if %i[api api_key api_proxy selenoid website].exclude?(type)
        return selenoid_credentials if type == :selenoid

        Interstellar::Credential.new(**credentials)
      end

      private

      attr_reader :type, :credentials

      def selenoid_credentials
        Interstellar::Credential.new(
          type: :selenoid,
          base_url: URI.parse(Rails.application.credentials.selenoid.base_url),
          browser: :chrome
        )
      end
    end
  end
end
