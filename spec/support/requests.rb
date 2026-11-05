require 'rack/test'

RSpec.shared_context('Hanami app') { let(:app) { Hanami.app } }

RSpec.configure do |config|
  config.include(Rack::Test::Methods, type: :request)
  config.include_context('Hanami app', type: :request)
end
