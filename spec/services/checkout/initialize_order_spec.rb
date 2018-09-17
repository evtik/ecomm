describe Ecomm::Checkout::InitializeOrder do
  describe '#call' do
    let(:service) do
      described_class.new(
        double('GetOrCreateAddress', call: attributes_for(:address))
      )
    end

    let(:session) { { items_total: 10.0, order_subtotal: 9.0 } }

    let(:order) { service.call(session, 1) }

    it 'returns OrderForm instance' do
      expect(order).to be_instance_of(Ecomm::OrderForm)
    end

    it 'assigns billing address' do
      expect(order.billing).to be_truthy
      expect(order.billing.country).to eq('Italy')
    end

    it 'assigns shipping address' do
      expect(order.shipping).to be_truthy
      expect(order.shipping.country).to eq('Italy')
    end

    it 'assigns items total value' do
      expect(order.items_total).to eq(10)
    end

    it 'assigns order subtotal value' do
      expect(order.subtotal).to eq(9)
    end

    it 'adds initialized order to session' do
      service.call(session, 1)
      expect(session[:order]).to be_truthy
    end
  end
end
