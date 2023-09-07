# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class Event < BaseObject
        field :code, Types::EventCategory, method: :type_code
        field :date_time, Types::DateTimeType
        field :location, Types::LocationType
      end
    end
  end
end
