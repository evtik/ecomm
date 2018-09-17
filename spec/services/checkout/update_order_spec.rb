describe Ecomm::Checkout::UpdateOrder do
  describe '#call' do
    let(:session) do
      order = Ecomm::OrderForm.from_model(build(:order))
      order.billing = Ecomm::AddressForm.from_model(build(:address))
      order.use_billing = true
      { order: order }
    end

    let(:order_params) do
      {
        'use_billing' => '0',
        'shipping' => attributes_for(
          :address, address_type: 'shipping', country: 'Schweiz'
        ),
        'card' => attributes_for(:credit_card, number: '1234-5678')
      }
    end

    let(:order) { described_class.call(session, order_params) }

    it 'returns OrderForm instance' do
      expect(order).to be_instance_of(Ecomm::OrderForm)
    end

    it 'updates order fields with those from params' do
      expect(order.shipping.country).to eq('Schweiz')
    end

    it 'removes possible dashes from order`s card number' do
      expect(order.card.number).to eq('12345678')
    end

    it 'saves updated order to session' do
      described_class.call(session, order_params)
      expect(session[:order][:use_billing]).to be false
      expect(session[:order][:shipping]).to be_truthy
      expect(session[:order][:card]).to be_truthy
    end
  end
end
