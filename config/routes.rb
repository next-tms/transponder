# frozen_string_literal: true

module Transponder
  class Routes < Hanami::Routes
    # root to: 'graphql.query'
    post "/graphql", to: "graphql.query"
  end
end
