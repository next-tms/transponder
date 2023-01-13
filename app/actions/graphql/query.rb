# frozen_string_literal: true

module Transponder
  module Actions
    module GraphQL
      class Query < Transponder::Action
        def handle(request, response)
          data = Transponder::GraphQL::TransponderSchema
                 .execute(
                   request.params[:query],
                   operation_name: request.params[:operationName],
                   # variables: JSON.parse(request.params.get(:variables, "{}")),
                 )

          response.format = :json
          response.body = data.to_json
        end
      end
    end
  end
end
