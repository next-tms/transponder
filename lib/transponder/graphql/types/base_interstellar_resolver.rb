# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class BaseInterstellarResolver < ::GraphQL::Schema::Resolver
        argument :scac, String, required: true
        argument :credentials, [::Transponder::GraphQL::Types::CarrierCredentialInputType], required: true

        def resolve(scac:, credentials:, **args)
          @scac = scac
          @interstellar_client = ::Transponder::InterstellarClient::BuildClient.new(
            scac: scac,
            credentials: credentials
          ).call

          call(**args)
        rescue StandardError => e
          raise ::GraphQL::ExecutionError, e.message
        rescue NotImplementedError => e
          raise ::GraphQL::ExecutionError, "No response returned from the API"
        end

        private

        attr_reader :scac, :interstellar_client
      end
    end
  end
end
