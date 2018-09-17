describe Ecomm::ShipmentForm, type: :form do
  context '#price=' do
    it 'converts to Money when String instance given' do
      expect(described_class.new(price: '5.23').price).to eq(Money.new(523))
    end
  end
end
