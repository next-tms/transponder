module Transponder
  module GraphQL
    module Types
      # Resolves `{ currency:, line: }`, because the invoice holds the currency of the line amounts.
      class InvoiceLineType < BaseObject
        field :balance, MoneyType, null: true
        field :bol_number, String, null: true
        field :delivered_on, ::GraphQL::Types::ISO8601Date, null: true
        field :destination, LocationType, null: true
        field :order_number, String, null: true
        field :origin, LocationType, null: true
        field :picked_up_on, ::GraphQL::Types::ISO8601Date, null: true
        field :po_number, String, null: true
        field :total, MoneyType, null: true
        field :tracking_number, String, null: true

        delegate :bol_number, :delivered_on, :destination, :order_number, :origin, :picked_up_on, :po_number, :tracking_number, to: :line

        def balance = money(line.balance_cents)
        def total = money(line.total_cents)

        private

        def line = object[:line]
        def money(cents) = cents && { currency: object[:currency], fractional: cents }
      end
    end
  end
end
