# frozen_string_literal: true

module Transponder
  module Actions
    module GraphQL
      class Query < Transponder::Action
        def handle(request, response)
          variables = request.params[:variables]

          Hanami.logger.debug(variables.inspect)
          begin
            data = Transponder::GraphQL::TransponderSchema
                   .execute(
                     request.params[:query],
                     operation_name: request.params[:operationName],
                     variables: variables,
                   )
          rescue NotImplementedError, StandardError => e
            response.format = :json
            response.body = { error: e.message }

            return
          end

          response.format = :json
          response.body = data.to_json
        end
      end
    end
  end
end
