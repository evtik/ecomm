describe Ecomm::Checkout::SubmitDeliveryStep, type: :command do
  describe '#call' do
    let(:params) { spy('params') }

    it 'with no order in session publishes :error and redirects to '\
    'show delivery step' do
      command = described_class.new(double('UpdateOrder', call: nil))
      expect { command.call({}, params) }.to(
        publish(:error, checkout_delivery_path)
      )
    end

    it 'with session order having no shipment set publishes :error and '\
    'redirects to show delivery step' do
      command = described_class.new(
        double('UpdateOrder', call: Ecomm::OrderForm.new)
      )
      expect { command.call({}, params) }.to(
        publish(:error, checkout_delivery_path)
      )
    end

    it 'with session order having shipment set publishes :ok and '\
    'redirects to show payment step' do
      order = Ecomm::OrderForm.from_params(
        shipment: Ecomm::ShipmentForm.from_model(build(:shipment))
      )
      command = described_class.new(double('UpdateOrder', call: order))
      expect { command.call({}, params) }.to(
        publish(:ok, checkout_payment_path)
      )
    end
  end
end
