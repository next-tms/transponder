# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class ShipmentInputType < ::GraphQL::Schema::InputObject
        argument :accessorials, [AccessorialInputType], required: false
        argument :declared_value, MoneyInputType, required: false
        argument :destination, LocationInputType, required: true
        argument :order_number, String, required: false
        argument :origin, LocationInputType, required: true
        argument :packages, [PackageInputType], required: true
        argument :pickup_at, DateTimeInputType, required: true
        argument :po_number, String, required: false
        argument :pro_number, String, required: false

        def prepare
          args = {
                   accessorials:,
                   declared_value_cents: declared_value.fractional,
                   destination:,
                   order_number:,
                   origin:,
                   packages:,
                   pickup_at:,
                   po_number:,
                   pro: pro_number
                 }.compact

          FreightKit::Shipment.new(**args)
        end
      end
    end
  end
end
