# frozen_string_literal: true

require "hanami"

module Transponder
  class App < Hanami::App
    config.inflections do |inflections|
      inflections.acronym("GraphQL")
      inflections.uncountable("GraphQL")
    end
  end
end
