module Transponder
  class Routes < Hanami::Routes
    get '/up', to: ->(*) { [200, { 'content-type' => 'text/plain' }, ['ok']] }

    post '/graphql', to: 'graphql.query'
  end
end
