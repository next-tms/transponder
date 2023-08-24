# frozen_string_literal: true

# rubocop:disable RSpec/FilePath
RSpec.describe(Transponder::Actions::GraphQL::Query) do
  let(:params) { Hash[] }
  let(:response) { subject.call(params) }

  it { expect(response).to(be_successful) }
end
# rubocop:enable RSpec/FilePath
