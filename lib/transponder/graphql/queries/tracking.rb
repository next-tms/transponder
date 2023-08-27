# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class Tracking < Transponder::GraphQL::Types::BaseFreightKitResolver
        type ::Transponder::GraphQL::Types::TrackingResponseType, null: true

        argument :tracking_number, String, required: true

        def call(tracking_number:)
          freight_kit_client.find_tracking_info(tracking_number)
        rescue NotImplementedError
          message = 'Tracking not supported by carrier'
          raise ::GraphQL::ExecutionError, message
        end
      end
    end
  end
end
