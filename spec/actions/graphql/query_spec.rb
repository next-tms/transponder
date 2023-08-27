# frozen_string_literal: true

# rubocop:disable RSpec/FilePath
RSpec.describe(Transponder::Actions::GraphQL::Query) do
  let(:operation_name) { nil }
  let(:query) { Faker::Alphanumeric }
  let(:variables) { nil }
  let(:params) do
    {}.tap do |builder|
      builder[:operation_name] = operation_name if operation_name
      builder[:query] = query if query
      builder[:variables] = variables if variables
    end
  end
  let(:response) { subject.call(params) }

  context 'when query is blank' do
    let(:query) { ['', nil].sample }

    it { expect(response.status).to(eq(400)) }
  end
end
# rubocop:enable RSpec/FilePath
