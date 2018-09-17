describe Ecomm::Checkout::ShowPaymentStep, type: :command do
  describe '#call' do
    it 'with no order in session publishes :denied event and '\
    'redirects to delivery step' do
      command = described_class.new(double('BuildOrder', call: nil))
      expect { command.call({}) }.to(
        publish(:denied, checkout_delivery_path)
      )
    end

    it 'with session order having no shipment set publishes :denied event '\
    'and redirects to delivery step' do
      order = Ecomm::OrderForm.from_params(
        attributes_for(:order, customer: build(:member))
      )
      command = described_class.new(double('BuildOrder', call: order))
      expect { command.call({}) }.to(
        publish(:denied, checkout_delivery_path)
      )
    end

    context 'with session order set and having shipment' do
      let(:order) do
        Ecomm::OrderForm.from_params(
          attributes_for(
            :order,
            customer: build(:member),
            shipment: Ecomm::ShipmentForm.from_model(build(:shipment))
          )
        )
      end

      let(:build_order) { double('BuildOrder', call: order) }

      it 'assigns empty CreditCardForm instance to order' do
        described_class.new(build_order).call({})
        expect(order.card).to be_truthy
      end

      it 'publishes :ok event passing order variable' do
        command = described_class.new(build_order)
        expect { command.call({}) }.to publish(:ok, order: order)
      end
    end
  end
end
