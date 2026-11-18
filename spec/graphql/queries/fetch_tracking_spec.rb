RSpec.describe(Transponder::GraphQL::Queries::FetchTracking) do
  let(:carrier_class) do
    tracking = self.tracking

    Class.new do
      define_singleton_method(:scac) { 'TEST' }
      define_method(:initialize) { |*, **| nil }
      define_method(:find_tracking_info) { |_tracking_number| tracking.call }
    end
  end
  let(:customer_location) do
    {
      address1: '123 Main St',
      city: 'Springfield',
      contact: { name: 'Example Shipper' },
      country: { alpha3: 'USA' },
      postalCode: '90266',
      regionAbbreviation: 'CA'
    }
  end
  let(:error) { result['errors']&.first }
  let(:query) do
    <<~GRAPHQL
      query($carrier: CarrierInput!) {
        fetchTracking(carrier: $carrier, trackingNumber: "123") { trackingNumber }
      }
    GRAPHQL
  end
  let(:result) { Transponder::GraphQL::TransponderSchema.execute(query, variables:) }
  let(:tracking) do
    raised = self.raised # `let` is not thread-safe across GraphQL::Dataloader fibers

    -> { raise(raised) }
  end
  let(:variables) do
    {
      carrier: {
        carrierCredentials: [{ password: 'password', type: 'website', username: 'username' }],
        customerLocation: customer_location,
        scac: 'TEST'
      }
    }
  end

  before { allow(FreightKit::Carriers).to(receive(:all).and_return([carrier_class])) }

  {
    FreightKit::ExpiredCredentialsError.new('Credentials expired') => 'INVALID_CREDENTIALS_ERROR',
    FreightKit::HTTPError.new(body: 'Bad Gateway', code: 502) => 'API_ERROR',
    FreightKit::InvalidCredentialsError.new('Invalid credentials') => 'INVALID_CREDENTIALS_ERROR',
    FreightKit::RateLimitError.new(body: 'Slow down', code: 429) => 'API_ERROR',
    FreightKit::ResponseError.new('API Error') => 'API_ERROR',
    FreightKit::ShipmentNotFoundError.new('Not found') => 'NOT_FOUND',
    HTTPX::ConnectionError.new('Connection refused') => 'API_ERROR',
    HTTPX::TimeoutError.new(30, 'Timed out after 30 seconds') => 'API_ERROR'
  }.each do |raised_error, code|
    context "when the carrier raises #{raised_error.class}" do
      let(:raised) { raised_error }

      it { expect(error).to(include('extensions' => { 'code' => code }, 'message' => raised_error.message)) }
      it { expect(result.dig('data', 'fetchTracking')).to(be_nil) }
    end
  end

  context 'when the carrier error message contains a host credential' do
    let(:raised) { HTTPX::ConnectionError.new('Connection refused by http://user:host-secret@proxy.example.com') }

    around do |example|
      ENV['FREIGHT_KIT_CARRIER_TEST_PROVIDER_API_KEY'] = 'host-secret'
      example.run
    ensure
      ENV.delete('FREIGHT_KIT_CARRIER_TEST_PROVIDER_API_KEY')
    end

    it { expect(error['message']).to(eq('Connection refused by http://user:[FILTERED]@proxy.example.com')) }
  end

  context 'when the carrier raises an unknown error' do
    let(:raised) { RuntimeError.new('Bug') }

    it { expect { result }.to(raise_error(RuntimeError, 'Bug')) }
  end

  context 'when the carrier returns tracking' do
    let(:tracking) { -> { Struct.new(:tracking_number).new('123') } }

    it { expect(result.to_h).to(eq('data' => { 'fetchTracking' => { 'trackingNumber' => '123' } })) }
  end
end
