require 'active_support/core_ext/integer/time'
require 'freight_kit'
require 'timeout'

module Transponder
  module GraphQL
    module Queries
      class FetchRates < ::GraphQL::Schema::Resolver
        include CarrierErrors

        class DeadlineExceededError < StandardError; end

        # Above FreightKit's 65 s `total_request_timeout`, so FreightKit reports a slow carrier first. TMS must wait
        # longer than this for `fetchRates`.
        DEADLINE = 2.minutes

        EXCEPTIONS = {
          DeadlineExceededError => { code: 'TIMEOUT_ERROR' },
          ::FreightKit::ExpiredCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
          ::FreightKit::HTTPError => { code: 'API_ERROR' },
          ::FreightKit::InvalidCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
          ::FreightKit::ResponseError => { code: 'API_ERROR' },
          ::FreightKit::UnserviceableAccessorialsError => { code: 'NOT_SERVICEABLE_ERROR' },
          ::FreightKit::UnserviceableError => { code: 'NOT_SERVICEABLE_ERROR' },
          ::HTTPX::Error => { code: 'API_ERROR' },
          ::NotImplementedError => { code: 'NOT_IMPLEMENTED_ERROR' },
          Types::CarrierInputType::CarrierNotFoundError => { code: 'CARRIER_NOT_KNOWN_ERROR' }
        }.freeze

        type ::Transponder::GraphQL::Types::RateResponseType, null: true

        argument :carrier, Types::CarrierInputType, required: true
        argument :shipment, Types::ShipmentInputType, required: true

        def resolve(carrier:, shipment:)
          message = "Carrier did not return rates within #{DEADLINE.inspect}"
          result = Timeout.timeout(DEADLINE, DeadlineExceededError, message) { carrier.find_rates(shipment:) }
          return result if result.error.blank?

          raise result.error
        rescue *EXCEPTIONS.keys => e
          raise_error(e)
        end
      end
    end
  end
end
