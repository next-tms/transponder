# frozen_string_literal: true

require 'money'

module Transponder
  module GraphQL
    module Types
      class ISO4217Type < BaseEnum
        ::Money::Currency.all.uniq(&:iso_code).sort_by(&:iso_code).each do |currency|
          value currency.iso_code, description: currency.name
        end
      end
    end
  end
end
