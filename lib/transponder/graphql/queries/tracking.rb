module Transponder
  module GraphQL
    module Queries
      class Tracking < ::Transponder::GraphQL::Types::BaseObject
        field :tracking_info, ::Transponder::GraphQL::Types::TrackingResponseType, null: true do
          argument :scac, String, required: true
          argument :tracking_number, String, required: true
          argument :credentials, ::Transponder::GraphQL::Types::CarrierCredentialInputType, required: true
        end

        ::Transponder::GraphQL::Types::QueryType.class_eval do
          def tracking_info(scac:, tracking_number:, credentials:)
            interstellar_client = ::Transponder::InterstellarClient::BuildClient.new(scac: scac, credentials: credentials).call
            response = interstellar_client.find_tracking_info(tracking_number)
            Hanami.logger.debug(response.inspect)
            response
          end
        end
      end
    end
  end
end
