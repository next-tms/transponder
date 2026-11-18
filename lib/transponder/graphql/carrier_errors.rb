module Transponder
  module GraphQL
    # Adds a carrier failure to the GraphQL response as an error with `extensions.code`, so the caller gets
    # `errors` instead of an HTTP 500. Include it in a resolver that defines `EXCEPTIONS`.
    module CarrierErrors
      private

      # `rescue` also catches subclasses, e.g. `RateLimitError < HTTPError`, so the code is found by ancestry.
      # @param [Exception] error
      def raise_error(error)
        code = self.class::EXCEPTIONS.find { |klass, _options| error.is_a?(klass) }.last[:code]
        message = HostCredentials.redact(error.message) if error.message != error.class.to_s

        context.add_error(::GraphQL::ExecutionError.new(message, extensions: { code: }))
      end
    end
  end
end
