describe Ecomm::Checkout::SubmitAddressStep, type: :command do
  describe '#call' do
    let(:params) { spy('params') }

    it 'with no order in session publishes :error event and redirects to '\
    'show address step' do
      command = described_class.new(double('UpdateOrder', call: nil))
      expect { command.call({}, params) }.to(
        publish(:error, checkout_address_path)
      )
    end

    it 'with invalid order addresses publishes :error event and redirects to '\
    'show address step' do
      order = Ecomm::OrderForm.from_params(
        use_billing: true,
        billing: attributes_for(:address, country: '')
      )
      command = described_class.new(double('UpdateOrder', call: order))
      expect { command.call({}, params) }.to(
        publish(:error, checkout_address_path)
      )
    end

    it 'with valid order addresses publishes :ok event and redirects to '\
    'show delivery step' do
      order = Ecomm::OrderForm.from_params(
        use_billing: true,
        billing: attributes_for(:address)
      )
      command = described_class.new(double('UpdateOrder', call: order))
      expect { command.call({}, params) }.to(
        publish(:ok, checkout_delivery_path)
      )
    end
  end
end
