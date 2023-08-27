# frozen_string_literal: true

require 'money'

module Transponder
  module GraphQL
    module Types
      class ISO4217Type < BaseEnum
        ::Money::Currency.all.map(&:iso_code).uniq.each { |iso4217| value iso4217 }
      end
    end
  end
end
