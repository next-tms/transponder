RSpec.describe(Transponder::LogFilter) do
  let(:filtered) { described_class.call(object) }

  context 'when carrier credentials are in GraphQL variables' do
    let(:object) do
      {
        carrier: {
          carrierCredentials: [
            {
              account: '123456',
              apiKey: 'api-key',
              password: 'saia-password',
              proxyUrl: 'http://user:secret@proxy.example.com',
              type: 'website',
              username: 'username'
            }
          ],
          scac: 'SAIA'
        }
      }
    end

    it do
      expect(filtered).to(
        eq(
          carrier: {
            carrierCredentials: [
              {
                account: '[FILTERED]',
                apiKey: '[FILTERED]',
                password: '[FILTERED]',
                proxyUrl: '[FILTERED]',
                type: 'website',
                username: '[FILTERED]'
              }
            ],
            scac: 'SAIA'
          }
        )
      )
    end

    it { expect { filtered }.not_to(change { object.dig(:carrier, :carrierCredentials, 0, :password) }) }
  end

  context 'when string keys hold tokens and secrets' do
    let(:object) { { 'accessToken' => 'token', 'clientSecret' => 'secret', 'Authorization' => 'Bearer token' } }

    it { expect(filtered.values).to(all(eq('[FILTERED]'))) }
  end

  context 'when GraphQL query text holds credentials as literals' do
    let(:object) { 'fetchRates(carrier: { carrierCredentials: [{ password: "p\"w", username : "username" }], scac: "SAIA" })' }

    it do
      expect(filtered).to(
        eq('fetchRates(carrier: { carrierCredentials: [{ password: "[FILTERED]", username : "[FILTERED]" }], scac: "SAIA" })')
      )
    end
  end

  context 'when the object is not a hash, array or string' do
    let(:object) { nil }

    it { expect(filtered).to(be_nil) }
  end
end
