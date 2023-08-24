# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class CarrierCredentialInputType < ::GraphQL::Schema::InputObject
        argument :account, String, required: false
        argument :api_key, String, required: false
        argument :base_url, String, required: false
        argument :browser, String, required: false
        argument :password, String, required: false
        argument :proxy_url, String, required: false
        argument :type, CarrierCredentialCategory, required: true
        argument :username, String, required: false
      end
    end
  end
end
