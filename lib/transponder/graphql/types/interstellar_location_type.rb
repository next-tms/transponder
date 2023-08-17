# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class InterstellarLocationType < BaseObject
        field :city, String, null: true
        field :country, Types::InterstellarCountryType
        field :province, String, null: true
        field :time_zone, String, null: true
      end
    end
  end
end
