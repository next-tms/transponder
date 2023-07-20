# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class InterstellarLocationType < BaseObject
        field :city, String
        field :country, Types::InterstellarCountryType
        field :province, String
      end
    end
  end
end
