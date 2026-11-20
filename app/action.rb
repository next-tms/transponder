# auto_register: false
require 'hanami/action'

module Transponder
  class Action < Hanami::Action
    ROUTER_PARAMS = 'router.params'.freeze

    # Hanami's request log line writes `router.params` after the action returns, so filter them on the way out.
    def call(env)
      super
    ensure
      env[ROUTER_PARAMS] = LogFilter.call(env[ROUTER_PARAMS]) if env.is_a?(Hash) && env.key?(ROUTER_PARAMS)
    end
  end
end
