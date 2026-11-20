RSpec.describe(Transponder::Actions::GraphQL::Query) do
  let(:operation_name) { nil }
  let(:query) { Faker::Alphanumeric }
  let(:variables) { nil }
  let(:params) do
    {}.tap do |builder|
      builder[:operationName] = operation_name if operation_name
      builder[:query] = query if query
      builder[:variables] = variables if variables
    end
  end
  let(:response) { subject.call(params) }

  context 'when query is blank' do
    let(:query) { ['', nil].sample }

    it { expect(response.status).to(eq(400)) }
  end

  context 'when variables hold carrier credentials' do
    let(:query) { '{ __typename }' }
    let(:variables) { { carrier: { carrierCredentials: [{ password: 'saia-password', type: 'website' }] } } }

    before { allow(Hanami.logger).to(receive(:debug)) }

    it 'does not log the password' do
      response

      expect(Hanami.logger).not_to(have_received(:debug).with(include('saia-password')))
    end

    it 'logs the filtered variables' do
      response

      expect(Hanami.logger).to(have_received(:debug).with(include('"password":"[FILTERED]"')))
    end

    # Hanami's request log line writes `router.params` once the action returns.
    context 'when Hanami logs the request params' do
      let(:env) { Rack::MockRequest.env_for('/graphql', method: 'POST').merge('router.params' => params) }
      let(:response) { subject.call(env) }

      before { response }

      it { expect(env.dig('router.params', :variables, :carrier, :carrierCredentials, 0, :password)).to(eq('[FILTERED]')) }
    end
  end

  context 'when operationName is null, as GraphiQL sends for anonymous queries' do
    let(:params) { { query: '{ __typename }', operationName: nil, variables: nil } }

    it { expect(response.status).to(eq(200)) }
    it { expect(JSON.parse(response.body.first)).to(eq('data' => { '__typename' => 'Query' })) }
  end
end
