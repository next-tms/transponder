module Transponder
  module GraphQL
    module Queries
      class FetchDocument < ::GraphQL::Schema::Resolver
        include CarrierErrors

        EXCEPTIONS = {
          ::FreightKit::DocumentNotFoundError => { code: 'NOT_FOUND' },
          ::FreightKit::ExpiredCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
          ::FreightKit::HTTPError => { code: 'API_ERROR' },
          ::FreightKit::InvalidCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
          ::FreightKit::ResponseError => { code: 'API_ERROR' },
          ::HTTPX::Error => { code: 'API_ERROR' },
          ::NotImplementedError => { code: 'NOT_IMPLEMENTED_ERROR' },
          Types::CarrierInputType::CarrierNotFoundError => { code: 'CARRIER_NOT_KNOWN_ERROR' }
        }.freeze

        type ::Transponder::GraphQL::Types::DocumentResponseType, null: true

        argument :carrier, Types::CarrierInputType, required: true
        argument :document_type, ::Transponder::GraphQL::Types::DocumentCategory, required: true
        argument :tracking_number, String, required: true

        def resolve(carrier:, document_type:, tracking_number:)
          carrier.public_send(document_type, tracking_number)
        rescue *EXCEPTIONS.keys => e
          raise_error(e)
        end
      end
    end
  end
end
