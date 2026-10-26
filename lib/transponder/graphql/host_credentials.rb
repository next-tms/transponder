module Transponder
  module GraphQL
    # Host-owned (Next TMS) carrier credentials, read from `FREIGHT_KIT_CARRIER_<SCAC>_PROVIDER_*`.
    module HostCredentials
      ENV_PATTERN = /\AFREIGHT_KIT_CARRIER_[A-Z0-9]+_PROVIDER_[A-Z_]+\z/
      FILTERED = '[FILTERED]'.freeze

      class << self
        # @param [String] scac
        # @return [Hash{Symbol => String}] `api_key` and `proxy_url`, when present
        def for(scac)
          prefix = "FREIGHT_KIT_CARRIER_#{scac.upcase}_PROVIDER"
          credentials = { api_key: ENV["#{prefix}_API_KEY"], proxy_url: ENV["#{prefix}_PROXY_URL"] }
          credentials.reject { |_key, value| value.to_s.empty? }
        end

        # Replaces every host-owned credential value in `object` with `FILTERED`, so carrier
        # request/response diagnostics never return Next TMS secrets to the caller.
        # @param [Object] object
        # @return [Object]
        def redact(object)
          secrets = values
          secrets.empty? ? object : redact_object(object, secrets)
        end

        private

        def redact_object(object, secrets)
          case object
          when Hash then object.to_h { |key, value| [key, redact_object(value, secrets)] }
          when Array then object.map { |value| redact_object(value, secrets) }
          when String then secrets.reduce(object) { |result, secret| result.gsub(secret, FILTERED) }
          when Symbol, Numeric, true, false, nil then object
          else redact_object(JSON.parse(object.to_json), secrets)
          end
        end

        # Raw, JSON-escaped and URL-encoded forms, plus any proxy URL password, longest first so a
        # secret containing another is fully replaced.
        def values
          secrets = ENV.select { |key, value| key.match?(ENV_PATTERN) && !value.to_s.empty? }.values
          secrets += secrets.flat_map { |secret| proxy_passwords(secret) }
          secrets += secrets.map { |secret| secret.to_json[1...-1] }
          secrets += secrets.flat_map { |secret| url_encodings(secret) }
          secrets.uniq.sort_by { |secret| -secret.length }
        end

        def proxy_passwords(secret)
          password = URI.parse(secret).password
          password.to_s.empty? ? [] : [password, URI.decode_uri_component(password)]
        rescue URI::InvalidURIError
          []
        end

        def url_encodings(secret) = [URI.encode_www_form_component(secret), URI.encode_uri_component(secret)]
      end
    end
  end
end
