# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class BaseField < ::GraphQL::Schema::Field
        argument_class BaseArgument
      end
    end
  end
end
