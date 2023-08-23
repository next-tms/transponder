# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class CarrierCredentialCategory < BaseEnum
        value "api", value: :api
        value "api_key", value: :api_key
        value "api_proxy", value: :api_proxy
        value "selenoid", value: :selenoid
        value "website", value: :website
      end
    end
  end
end
