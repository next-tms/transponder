module Transponder
  # Replaces credential values with `FILTERED` before they reach the logs, e.g. `carrierCredentials` in GraphQL
  # `variables`. Hanami's `config.logger.filters` does not reach hashes inside arrays, so it misses them.
  module LogFilter
    FILTERED = '[FILTERED]'.freeze
    KEY_PATTERN = /account|authorization|key|password|proxy|secret|token|username/i
    # A sensitive argument written inline in GraphQL query text, e.g. `password: "secret"`.
    LITERAL_PATTERN = /\b(\w*(?:#{KEY_PATTERN.source})\w*)(\s*:\s*)"(?:[^"\\]|\\.)*"/i

    class << self
      # @param [Object] object
      # @return [Object]
      def call(object)
        case object
        when Hash then object.to_h { |key, value| [key, KEY_PATTERN.match?(key.to_s) ? FILTERED : call(value)] }
        when Array then object.map { |value| call(value) }
        when String then object.gsub(LITERAL_PATTERN, "\\1\\2\"#{FILTERED}\"")
        else object
        end
      end
    end
  end
end
