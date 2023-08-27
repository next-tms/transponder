# frozen_string_literal: true

require 'money'

module Transponder
  module GraphQL
    module Types
      class ISO4217InputType < ::GraphQL::Schema::InputObject
        argument :iso4217, String, required: true
      end
    end
  end
end
