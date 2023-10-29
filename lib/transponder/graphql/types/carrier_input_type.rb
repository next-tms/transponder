# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class CarrierInputType < ::GraphQL::Schema::InputObject
        class CarrierNotFoundError < StandardError; end

        argument :carrier_credentials, [CarrierCredentialInputType], required: true
        argument :customer_location, CustomerLocationInputType, required: true
        argument :scac, String, required: true
        argument :tariff, TariffInputType, required: false

        def prepare
          carrier = ::FreightKit::Carriers.all.find { |carrier| carrier.scac&.downcase == scac.to_s.downcase }
          raise CarrierNotFoundError, "Carrier with SCAC code #{scac.upcase} not found" unless carrier

          kwargs = { customer_location:, tariff: }.compact

          carrier.new(carrier_credentials, **kwargs)
        end
      end
    end
  end
end
