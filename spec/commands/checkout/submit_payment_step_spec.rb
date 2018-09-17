describe Ecomm::Checkout::SubmitPaymentStep, type: :command do
  describe '#call' do
    let(:params) { spy('params') }

    it 'with no order in session publishes :error and redirects to '\
    'show payment step' do
      command = described_class.new(double('UpdateOrder', call: nil))
      expect { command.call({}, params) }.to(
        publish(:error, checkout_payment_path)
      )
    end

    it 'with session order having no card set publishes :error and '\
    'redirects to show payment step' do
      command = described_class.new(
        double('UpdateOrder', call: Ecomm::OrderForm.new)
      )
      expect { command.call({}, params) }.to(
        publish(:error, checkout_payment_path)
      )
    end

    it 'with session order having invalid card publishes :error and '\
    'redirects to show payment step' do
      order = Ecomm::OrderForm.from_params(
        card: Ecomm::CreditCardForm.from_model(build(:credit_card, number: ''))
      )
      command = described_class.new(double('UpdateOrder', call: order))
      expect { command.call({}, params) }.to(
        publish(:error, checkout_payment_path)
      )
    end

    it 'with session order having valid card publishes :ok and '\
    'redirects to show confirm step' do
      order = Ecomm::OrderForm.from_params(
        card: Ecomm::CreditCardForm.from_model(build(:credit_card))
      )
      command = described_class.new(double('UpdateOrder', call: order))
      expect { command.call({}, params) }.to(
        publish(:ok, checkout_confirm_path)
      )
    end
  end
end
