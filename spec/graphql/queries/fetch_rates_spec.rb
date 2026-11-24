RSpec.describe(Transponder::GraphQL::Queries::FetchRates) do
  let(:carrier_class) do
    rates = self.rates

    Class.new do
      define_singleton_method(:scac) { 'TEST' }
      define_method(:initialize) { |*, **| nil }
      define_method(:find_rates) { |shipment:| rates.call(shipment) }
    end
  end
  let(:error) { result['errors']&.first }
  let(:location) { { country: { alpha3: 'USA' }, postalCode: '90266', regionAbbreviation: 'CA' } }
  let(:package) do
    {
      dimensions: { height: length, length:, width: length },
      hazardous: false,
      packaging: 'pallet',
      weight: { amount: 500.0, unit: 'lb' }
    }
  end
  let(:length) { { amount: 48.0, unit: 'in' } }
  let(:query) do
    <<~GRAPHQL
      query($carrier: CarrierInput!, $shipment: ShipmentInput!) {
        fetchRates(carrier: $carrier, shipment: $shipment) { rates { __typename } }
      }
    GRAPHQL
  end
  let(:result) { Transponder::GraphQL::TransponderSchema.execute(query, variables:) }
  let(:variables) do
    {
      carrier: {
        carrierCredentials: [{ password: 'password', type: 'website', username: 'username' }],
        customerLocation: location.merge(address1: '123 Main St', city: 'Springfield', contact: { name: 'Example' }),
        scac: 'TEST'
      },
      shipment: {
        declaredValue: { currency: 'USD', fractional: 0 },
        destination: location,
        origin: location,
        packages: [package],
        pickupAt: { iso8601: '2026-11-20T09:00:00-08:00' }
      }
    }
  end

  before do
    allow(FreightKit::Carriers).to(receive(:all).and_return([carrier_class]))
    stub_const("#{described_class}::DEADLINE", 0.1.seconds)
  end

  context 'when the carrier does not return rates before the deadline' do
    let(:rates) { ->(_shipment) { sleep(5) } }

    it { expect(error).to(include('extensions' => { 'code' => 'TIMEOUT_ERROR' })) }
    it { expect(error['message']).to(eq('Carrier did not return rates within 0.1 seconds')) }
    it { expect(result.dig('data', 'fetchRates')).to(be_nil) }

    it 'frees the thread before the carrier finishes' do
      started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      result

      expect(Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at).to(be < 1)
    end
  end

  # freight_kit's own HTTP timeouts end a slow carrier call before the deadline does.
  context 'when the carrier HTTP read times out' do
    let(:rates) { ->(_shipment) { raise(HTTPX::ReadTimeoutError.new(nil, nil, 15)) } }

    it { expect(error).to(include('extensions' => { 'code' => 'API_ERROR' })) }
    it { expect(result.dig('data', 'fetchRates')).to(be_nil) }
  end

  context 'when the carrier returns rates before the deadline' do
    let(:rates) { ->(_shipment) { Struct.new(:error, :rates).new(nil, []) } }

    it { expect(result.to_h).to(eq('data' => { 'fetchRates' => { 'rates' => [] } })) }
  end
end
