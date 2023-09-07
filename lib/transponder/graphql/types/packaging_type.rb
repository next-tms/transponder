# frozen_string_literal: true

require 'freight_kit'

module Transponder
  module GraphQL
    module Types
      class PackagingType < BaseEnum
        description "See https://github.com/next-tms/freight_kit/blob/v#{FreightKit::VERSION}/lib/freight_kit/packaging.rb"

        FreightKit::Packaging::VALID_TYPES.uniq.sort.map { |packaging| value packaging }
      end
    end
  end
end
