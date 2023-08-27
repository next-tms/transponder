# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class BaseFreightKitResolver < ::GraphQL::Schema::Resolver
        argument :credentials, [::Transponder::GraphQL::Types::CarrierCredentialInputType], required: true
        argument :customer_location, ::Transponder::GraphQL::Types::CustomerLocationInputType, required: true
        argument :scac, String, required: true
        argument :tariff, ::Transponder::GraphQL::Types::TariffInputType, required: false

        def resolve(credentials:, customer_location:, scac:, tariff: nil, **args)
          @customer_location = customer_location
          @scac = scac
          @tariff = tariff

          client_args = { credentials:, customer_location:, scac: }
          client_args[:tariff] = tariff if tariff.present?

          @freight_kit_client = ::Transponder::FreightKitClient::BuildClient.new(**client_args).call

          call(**args)
        rescue Transponder::FreightKitClient::BuildClient::CarrierNotImplmentedError, NotImplementedError => e
          raise ::GraphQL::ExecutionError, e.message
        end

        private

        attr_reader :freight_kit_client, :scac
      end
    end
  end
end
