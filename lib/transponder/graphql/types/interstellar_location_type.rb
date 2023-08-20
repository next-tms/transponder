# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class FreightKitLocationType < BaseObject
        field :city, String
        field :country, Types::FreightKitCountryType
        field :province, String
      end
    end
  end
end
