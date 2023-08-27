# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class LengthInputType < ::GraphQL::Schema::InputObject
        argument :cm, Float, required: false
        argument :ft, Float, required: false
        argument :in, Float, required: false
        argument :m, Float, required: false
      end
    end
  end
end
