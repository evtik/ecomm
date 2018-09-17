describe Ecomm::Checkout::BuildOrder do
  describe '#call' do
    let(:session) do
      order = Ecomm::OrderForm.from_model(build(:order))
      order.billing = Ecomm::AddressForm.from_model(build(:address))
      { order: order }
    end

    let(:order) { described_class.call(session) }

    it 'returns Ecomm::OrderForm instance' do
      expect(order).to be_instance_of(Ecomm::OrderForm)
    end

    it 'populates order fields' do
      expect(order.billing).to be_truthy
      expect(order.billing.country).to eq('Italy')
    end

    it 'ensures returned order to have been validated' do
      expect_any_instance_of(Ecomm::OrderForm).to receive(:valid?)
      described_class.call(session)
    end
  end
end
