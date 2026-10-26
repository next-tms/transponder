module Transponder
  module GraphQL
    module Types
      class RateResponseType < BaseObject
        field :rates, [Types::RateType]
        field :request, ::GraphQL::Types::JSON, null: true
        field :response, ::GraphQL::Types::JSON, null: true

        def request = HostCredentials.redact(object.request)
        def response = HostCredentials.redact(object.response)
      end
    end
  end
end
