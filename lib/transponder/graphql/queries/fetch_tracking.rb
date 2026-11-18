require 'freight_kit'

module Transponder
  module GraphQL
    module Queries
      class FetchTracking < ::GraphQL::Schema::Resolver
        include CarrierErrors

        EXCEPTIONS = {
          ::FreightKit::ExpiredCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
          ::FreightKit::HTTPError => { code: 'API_ERROR' },
          ::FreightKit::InvalidCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
          ::FreightKit::ResponseError => { code: 'API_ERROR' },
          ::FreightKit::ShipmentNotFoundError => { code: 'NOT_FOUND' },
          ::HTTPX::Error => { code: 'API_ERROR' },
          ::NotImplementedError => { code: 'NOT_IMPLEMENTED_ERROR' },
          Types::CarrierInputType::CarrierNotFoundError => { code: 'CARRIER_NOT_KNOWN_ERROR' }
        }.freeze

        type ::Transponder::GraphQL::Types::TrackingResponseType, null: true

        argument :carrier, Types::CarrierInputType, required: true
        argument :tracking_number, String, required: true

        def resolve(carrier:, tracking_number:)
          carrier.find_tracking_info(tracking_number)
        rescue *EXCEPTIONS.keys => e
          raise_error(e)
        end
      end
    end
  end
end
