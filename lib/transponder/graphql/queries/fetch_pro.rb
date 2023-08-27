# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class FetchPro < Transponder::GraphQL::Types::BaseFreightKitResolver
        type String, null: true

        argument :dispatched_at, ::GraphQL::Types::ISO8601Date, required: false
        argument :pickup_number, String, required: true
        argument :pickup_on, ::GraphQL::Types::ISO8601Date, required: false

        def call(pickup_number:, pickup_on: nil, dispatched_at: nil)
          pro = nil

          if pickup_on
            [
              pickup_on.to_date,
              pickup_on.to_date - 1.day,
              pickup_on.to_date + 1.day,
              pickup_on.to_date + 2.days,
            ].each do |date|
              pro = freight_kit_client.find_tracking_number_from_pickup_number(pickup_number, date)
              break if pro.present?
            end
          end

          return pro if pro
          return unless dispatched_at

          [dispatched_at.to_date, dispatched_at.to_date + 1.day].each do |date|
            pro = freight_kit_client.find_tracking_number_from_pickup_number(pickup_number, date)
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
