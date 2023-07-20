module Transponder
  module GraphQL
    module Queries
      class Tracking < Transponder::GraphQL::Types::BaseInterstellarResolver
        type ::Transponder::GraphQL::Types::TrackingResponseType, null: true

        argument :tracking_number, String, required: true

        def call(tracking_number:)
          response = interstellar_client.find_tracking_info(tracking_number)
          Hanami.logger.debug(response.inspect)
          response
        end
      end
    end
  end
end
