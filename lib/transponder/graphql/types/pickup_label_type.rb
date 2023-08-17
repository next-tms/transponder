# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class PickupLabelType < BaseObject
        field :data, String, null: true
      end
    end
  end
end
