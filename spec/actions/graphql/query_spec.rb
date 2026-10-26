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

  context 'when operationName is null, as GraphiQL sends for anonymous queries' do
    let(:params) { { query: '{ __typename }', operationName: nil, variables: nil } }

    it { expect(response.status).to(eq(200)) }
    it { expect(JSON.parse(response.body.first)).to(eq('data' => { '__typename' => 'Query' })) }
  end
end
