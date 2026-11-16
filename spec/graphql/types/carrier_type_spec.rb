RSpec.describe(Transponder::GraphQL::Types::CarrierType) do
  let(:query) do
    <<~GRAPHQL
      query($destination: LocationInput!, $origin: LocationInput!, $scac: String!) {
        fetchCarrier(scac: $scac) {
          lanes { destination { regionAbbreviation } id origin { country { alpha2 } postalCodes regionAbbreviation } }
          matchingLanes(destination: $destination, origin: $origin) { id }
          serve(destination: $destination, origin: $origin)
          territories { regionAbbreviation }
        }
      }
    GRAPHQL
  end
  let(:carrier) { result.dig('data', 'fetchCarrier') }
  let(:destination) { { country: { alpha2: 'US' }, postalCode: '84101', regionAbbreviation: 'UT' } }
  let(:origin) { { country: { alpha2: 'US' }, postalCode: '90001', regionAbbreviation: 'CA' } }
  let(:result) { Transponder::GraphQL::TransponderSchema.execute(query, variables: { destination:, origin:, scac: }) }
  let(:scac) { 'WRDS' }

  it { expect(result['errors']).to(be_nil) }

  it do
    expect(carrier['lanes'])
      .to(
        include(
          'destination' => { 'regionAbbreviation' => 'UT' },
          'id' => 'f6f9fccd-8ce1-43ca-a4a3-36c12d3f309c',
          'origin' => { 'country' => { 'alpha2' => 'US' }, 'postalCodes' => [], 'regionAbbreviation' => 'CA' }
        )
      )
  end

  it { expect(carrier['matchingLanes']).to(eq([{ 'id' => 'f6f9fccd-8ce1-43ca-a4a3-36c12d3f309c' }])) }
  it { expect(carrier['serve']).to(be(true)) }
  it { expect(carrier['territories']).to(be_empty) }

  context 'when the lane runs the other way' do
    let(:destination) { { country: { alpha2: 'US' }, regionAbbreviation: 'CA' } }
    let(:origin) { { country: { alpha2: 'US' }, regionAbbreviation: 'UT' } }

    it { expect(carrier['matchingLanes']).to(be_empty) }
    it { expect(carrier['serve']).to(be(false)) }
  end

  context 'without lanes or territories' do
    let(:scac) { 'SAIA' }

    it { expect(carrier['lanes']).to(be_empty) }
    it { expect(carrier['serve']).to(be(true)) }
  end
end
