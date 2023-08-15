# frozen_string_literal: true

require "hanami"

module Transponder
  class App < Hanami::App
    config.inflections do |inflections|
      inflections.acronym("GraphQL")
      inflections.acronym("ISO")
      inflections.acronym("SCAC")
    end

    config.middleware.use(:body_parser, :json)
  end
end
