# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class CarrierCredentialInputType < ::GraphQL::Schema::InputObject
        argument :account, String, required: false
        argument :username, String, required: false
        argument :password, String, required: false
        argument :api_key, String, required: false
        argument :proxy_url, String, required: false
        argument :type, CarrierCredentialCategory, required: true
      end
    end
  end
end
