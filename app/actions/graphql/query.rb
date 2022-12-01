# frozen_string_literal: true

module Transponder
  module Actions
    module GraphQL
      class Query < Transponder::Action
        def handle(request, response)
          data = Transponder::GraphQL::TransponderSchema
                 .execute(
                   request.params[:query],
                   variables: request.params[:variables],
                 )
          json = JSON.generate(data)

          response.body = json
        end
      end
    end
  end
end
