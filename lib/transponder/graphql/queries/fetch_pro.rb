# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class FetchPro < ::GraphQL::Schema::Resolver
        type String, null: true

        argument :carrier, Types::CarrierInputType, required: true
        argument :dispatched_on, ::GraphQL::Types::ISO8601Date, required: false
        argument :picked_up_on, ::GraphQL::Types::ISO8601Date, required: false
        argument :pickup_number, String, required: true

        def resolve(carrier:, pickup_number:, dispatched_on: nil, picked_up_on: nil)
          pro = nil

          if picked_up_on
            [
              picked_up_on,
              picked_up_on - 1.day,
              picked_up_on + 1.day,
              picked_up_on + 2.days,
            ].each do |date|
              pro = carrier.find_tracking_number_from_pickup_number(pickup_number, date)
              break if pro.present?
            end
          end

          return pro if pro
          return unless dispatched_on

          [dispatched_on, dispatched_on + 1.day].each do |date|
            pro = carrier.find_tracking_number_from_pickup_number(pickup_number, date)
            break if pro.present?
          end

          pro
        rescue NotImplementedError
          message = 'Pro number retrieval from pickup number not supported by carrier'
          raise ::GraphQL::ExecutionError, message
        end
      end
    end
  end
end
