# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class BaseInterstellarResolver < ::GraphQL::Schema::Resolver
        argument :scac, String, required: true
        argument :credentials, [::Transponder::GraphQL::Types::CarrierCredentialInputType], required: true

        def resolve(scac:, credentials:, **args)
          @interstellar_client = ::Transponder::InterstellarClient::BuildClient.new(
            scac: scac,
            credentials: credentials
          ).call

          call(**args)
        end

        private

        attr_reader :interstellar_client
      end
    end
  end
end
