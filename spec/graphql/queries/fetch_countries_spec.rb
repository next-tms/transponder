RSpec.describe(Transponder::GraphQL::Queries::FetchCountries) do
  let(:query) do
    <<~GRAPHQL
      query($alpha2: [ISO31661Alpha2!], $name: String) {
        fetchCountries(alpha2: $alpha2, name: $name) { alpha2 }
      }
    GRAPHQL
  end
  let(:variables) { {} }
  let(:result) { Transponder::GraphQL::TransponderSchema.execute(query, variables:) }
  let(:alpha2s) { result.dig('data', 'fetchCountries').map { |country| country['alpha2'] } }

  context 'without arguments' do
    it { expect(alpha2s.size).to(eq(FreightKit::Countries.all.size)) }
  end

  context 'with alpha2' do
    let(:variables) { { alpha2: ['CA', 'US'] } }

    it { expect(alpha2s).to(contain_exactly('CA', 'US')) }
  end

  context 'with name' do
    {
      'United States' => ['US'],
      'united states' => ['US'],
      ' United States ' => ['US'],
      'USA' => ['US'],
      'us' => ['US'],
      'can' => ['CA'],
      'Deutschland' => ['DE'],
      'Narnia' => [],
      '' => []
    }.each do |name, expected|
      context "when name is #{name.inspect}" do
        let(:variables) { { name: } }

        it { expect(alpha2s).to(eq(expected)) }
      end
    end
  end

  context 'with alpha2 and name' do
    let(:variables) { { alpha2:, name: 'United States' } }

    context 'when alpha2 includes the named country' do
      let(:alpha2) { ['CA', 'US'] }

      it { expect(alpha2s).to(eq(['US'])) }
    end

    context 'when alpha2 excludes the named country' do
      let(:alpha2) { ['CA'] }

      it { expect(alpha2s).to(be_empty) }
    end
  end
end
