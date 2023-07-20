# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class LengthType < BaseObject
        field :cm, Float, null: false
        def cm
          object.convert_to(:cm).value
        end

        field :ft, Float, null: false
        def ft
          object.convert_to(:ft).value
        end

        field :in, Float, null: false, resolver_method: :resolve_in
        def resolve_in
          object.convert_to(:in).value
        end

        field :m, Float, null: false
        def m
          object.convert_to(:m).value
        end
      end
    end
  end
end
