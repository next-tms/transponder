module Transponder
  module GraphQL
    module Types
      class InvoiceResponseType < DocumentResponseType
        field :balance, MoneyType, null: true
        field :issued_on, ::GraphQL::Types::ISO8601Date, null: true
        field :lines, [InvoiceLineType], null: false
        field :number, String, null: true
        field :total, MoneyType, null: true

        def balance = money(object.balance_cents)
        def document = (super if object.data)
        def lines = object.lines.to_a.map { |line| { currency: object.currency, line: } }
        def total = money(object.total_cents)

        private

        def money(cents) = cents && { currency: object.currency, fractional: cents }
      end
    end
  end
end
