# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class FetchTracking < ::GraphQL::Schema::Resolver
        type ::Transponder::GraphQL::Types::TrackingResponseType, null: true

        argument :carrier, Types::CarrierInputType, required: true
        argument :tracking_number, String, required: true

        def resolve(carrier:, tracking_number:)
          carrier.find_tracking_info(tracking_number)
        rescue NotImplementedError
          message = 'Tracking not supported by carrier'
          raise ::GraphQL::ExecutionError, message, extensions: { code: 'NOT_IMPLEMENTED_ERROR' }
        end
      end
    end
  end
end
