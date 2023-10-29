# frozen_string_literal: true

module Transponder
  module Actions
    module GraphQL
      class Query < Transponder::Action
        handle_exception StandardError => :handle_standard_error

        params do
          required(:query).filled.value(:string)

          optional(:operationName).filled.value(:string)
          optional(:variables)
        end

        def handle(request, response)
          response.format = :json

          unless request.params.valid?
            errors = request.params.errors.map do |key, values|
              "#{key} #{values.join(", ")}"
            end
            data = { errors: }

            halt(400, serialize(data))
          end

          operation_name = request.params[:operationName]
          query = request.params[:query]
          variables = request.params[:variables]

          Hanami.logger.debug(query)
          Hanami.logger.debug(variables.to_json)

          data = Transponder::GraphQL::TransponderSchema
                 .execute(
                   query,
                   operation_name:,
                   variables:,
                 )

          response.body = data.to_json
        end

        private

        def handle_standard_error(request, response, exception)
          response.format = :json
          response.status = 200

          data = {
                   errors: [
                             { message: 'Sorry, something went wrong handling your request' },
                           ]
                 }

          response.body = serialize(data)

          raise exception
        end

        def serialize(data)
          data.to_json
        end
      end
    end
  end
end
