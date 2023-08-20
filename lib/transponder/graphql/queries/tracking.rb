module Transponder
  module GraphQL
    module Queries
      class Tracking < Transponder::GraphQL::Types::BaseFreightKitResolver
        type ::Transponder::GraphQL::Types::TrackingResponseType, null: true

        argument :tracking_number, String, required: true

        def call(tracking_number:)
          response = freight_kit_client.find_tracking_info(tracking_number)
          Hanami.logger.debug(response.inspect)
          response
        end
      end
    end
  end
end
