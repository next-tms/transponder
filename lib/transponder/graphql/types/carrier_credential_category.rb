# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class CarrierCredentialCategory < BaseEnum
        value "API", value: :api
        value "WEBSITE", value: :api
      end
    end
  end
end
