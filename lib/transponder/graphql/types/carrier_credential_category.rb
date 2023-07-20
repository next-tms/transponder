# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class CarrierCredentialCategory < BaseEnum
        value "api", value: :api
        value "website", value: :website
      end
    end
  end
end
