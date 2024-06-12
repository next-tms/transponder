# frozen_string_literal: true

module Transponder
  module GraphQL
    module Queries
      class FetchPro < ::GraphQL::Schema::Resolver
        EXCEPTIONS = {
                       ::FreightKit::ExpiredCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
                       ::FreightKit::InvalidCredentialsError => { code: 'INVALID_CREDENTIALS_ERROR' },
                       ::FreightKit::ResponseError => { code: 'API_ERROR' },
                       ::FreightKit::ShipmentNotFoundError => { code: 'NOT_FOUND' },
                       ::NotImplementedError => { code: 'NOT_IMPLEMENTED_ERROR' },
                       Types::CarrierInputType::CarrierNotFoundError => { code: 'CARRIER_NOT_KNOWN_ERROR' }
                     }

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
        rescue *EXCEPTIONS.keys => e
          raise_error(e)
        end

        private

        def raise_error(error)
          code = EXCEPTIONS[error.class][:code]
          message = error.message if error.message != error.class.to_s

          context.add_error(::GraphQL::ExecutionError.new(message, extensions: { code: }))
        end
      end
    end
  end
end
