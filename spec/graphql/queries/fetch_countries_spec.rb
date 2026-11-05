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
      ' United States ' => ['US'],
      '' => [],
      'can' => ['CA'],
      'Deutschland' => ['DE'],
      'Narnia' => [],
      'united states' => ['US'],
      'United States' => ['US'],
      'us' => ['US'],
      'USA' => ['US']
    }.each do |name, expected|
      context "when name is #{name.inspect}" do
        let(:variables) { { name: } }

        it { expect(alpha2s).to(eq(expected)) }
      end
    end
  end

  context 'with postal code fields' do
    let(:query) do
      <<~GRAPHQL
        query($alpha2: [ISO31661Alpha2!]) {
          fetchCountries(alpha2: $alpha2) { alpha2 postalCode postalCodeFormat postalCodeLabel }
        }
      GRAPHQL
    end
    let(:countries) { result.dig('data', 'fetchCountries').index_by { |country| country['alpha2'] } }

    it do
      expect(countries['US'])
        .to(
          include(
            'postalCode' => true,
            'postalCodeFormat' => '(\d{5})(?:[ \-](\d{4}))?',
            'postalCodeLabel' => 'ZIP'
          )
        )
    end

    it { expect(countries['AE']).to(include('postalCode' => false, 'postalCodeFormat' => nil)) }
    it { expect(countries['DE']).to(include('postalCodeFormat' => '\d{5}', 'postalCodeLabel' => 'PLZ')) }
    it { expect(countries['FR']).to(include('postalCode' => true, 'postalCodeLabel' => 'Postal code')) }

    it 'returns formats without Ruby-only anchors' do
      formats = countries.values.filter_map { |country| country['postalCodeFormat'] }

      expect(formats).to(all(satisfy { |format| !format.match?(/\\[AZz]/) }))
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
