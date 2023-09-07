# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class AccessorialInputType < ::GraphQL::Schema::InputObject
        argument :code, AccessorialCategory, required: true

        def prepare
          code.to_sym
        end
      end
    end
  end
end
