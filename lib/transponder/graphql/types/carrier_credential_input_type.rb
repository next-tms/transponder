module Transponder
  module GraphQL
    module Types
      class CarrierCredentialInputType < ::GraphQL::Schema::InputObject
        HOST_CREDENTIAL_TYPES = %i[api api_key api_proxy].freeze

        argument :account, String, required: false
        argument :api_key, String, required: false
        argument :base_url, String, required: false
        argument :browser, String, required: false
        argument :password, String, required: false
        argument :proxy_url, String, required: false
        argument :type, CarrierCredentialCategory, required: true
        argument :username, String, required: false

        # @note Host-owned (Next TMS) `api_key` and `proxy_url` win over the input, as in a brokered
        #   connection. The tenant's `account`, `username` and `password` are never replaced.
        # @param [String] scac
        # @return [FreightKit::Credential]
        def to_credential(scac:)
          if type == :selenoid
            return FreightKit::Credential.new(
              type: :selenoid,
              base_url: URI.parse(ENV.fetch('SELENOID_BASE_URL')),
              browser: :chrome
            )
          end

          args = { account:, api_key:, base_url:, browser:, password:, proxy_url:, type:, username: }.compact
          args.merge!(HostCredentials.for(scac)) if HOST_CREDENTIAL_TYPES.include?(type)

          FreightKit::Credential.new(**args)
        end
      end
    end
  end
end
