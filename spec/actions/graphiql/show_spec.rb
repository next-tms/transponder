RSpec.describe(Transponder::Actions::GraphiQL::Show) do
  let(:response) { subject.call({}) }

  it { expect(response.status).to(eq(200)) }
  it { expect(response.headers['Content-Type']).to(include('text/html')) }
  it { expect(response.body.first).to(include("createFetcher({ url: '/graphql' })")) }
  it { expect(response.headers['Content-Security-Policy']).to(include("script-src 'self' https://unpkg.com 'sha256-")) }
end
