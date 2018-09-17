describe Ecomm::Cart::CalculateCartTotals do
  describe '#call' do
    let(:total) { Money.new(1500) }
    before { create_list(:raw_product, 3) }

    it 'returns correct totals with no discount given' do
      session = { cart: { 1 => 2, 2 => 4, 3 => 9 } }
      result = described_class.call(session)
      expect(result).to eq([total, total, 0.0])
    end

    it 'returns correct totals with particular discount given' do
      session = { cart: { 1 => 2, 2 => 4, 3 => 9 }, discount: 10 }
      result = described_class.call(session)
      expect(result).to eq([total, Money.new(1350), Money.new(150)])
    end
  end
end
