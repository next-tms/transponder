# frozen_string_literal: true

require "hanami"
require 'honeybadger'

module Transponder
  class App < Hanami::App
    config.inflections do |inflections|
      inflections.acronym("GraphQL")
      inflections.acronym("ISO")
      inflections.acronym("SCAC")
    end

    config.middleware.use(:body_parser, :json)
    config.middleware.use Honeybadger::Rack::ErrorNotifier
  end
end
