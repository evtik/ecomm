describe Ecomm::Common::BuildLineItemsFromCart do
  describe '#call' do
    it 'returns array of LineItems corresponding to cart items' do
      cart = { 1 => 4, 2 => 8, 3 => 12 }
      described_class.call(cart).each.with_index do |item, index|
        expect(item).to be_instance_of(Ecomm::LineItem)
        expect(item.product_id).to eq(index + 1)
        expect(item.quantity).to eq((index + 1) * 4)
      end
    end
  end
end
