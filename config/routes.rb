# frozen_string_literal: true

module Transponder
  class Routes < Hanami::Routes
    post '/graphql', to: 'graphql.query'
  end
end
