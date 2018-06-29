describe Ecomm::Checkout::ShowAddressStep, type: :command do
  describe '#call' do
    context 'with cart blank or empty' do
      it 'with nil cart publishes :denied event and redirects to cart' do
        session = { cart: nil }
        expect { described_class.call(session, nil) }.to(
          publish(:denied, cart_path)
        )
      end

      it 'with empty cart publishes :denied event and redirects to cart' do
        session = { cart: {} }
        expect { described_class.call(session, nil) }.to(
          publish(:denied, cart_path)
        )
      end
    end

    context 'with products in cart' do
      let(:customer) { build(:member) }
      let(:session) { { cart: { '2' => 4 } } }
      let(:get_totals) { double('CalculateCartTotals', call: [5.0, 7.0]) }
      let(:initialized_order) { build(:order, customer: customer) }
      let(:initializer) { double('InitializeOrder', call: initialized_order) }
      let(:countries) { ['Mali'] }
      let(:get_countries) { double('GetCountries', call: countries) }

      it 'assigns session order totals' do
        session_order = build(:order, customer: customer)
        builder = double('BuildOrder', call: session_order)
        command = described_class.new(get_totals, builder, initializer,
                                      get_countries)
        command.call(session, nil)
        expect(session[:items_total]).to eq(5)
        expect(session[:order_subtotal]).to eq(7)
      end

      it 'with order existing in session '\
      'publishes :ok event passing session order and countries variables' do
        session_order = build(:order, customer: customer)
        builder = double('BuildOrder', call: session_order)
        command = described_class.new(get_totals, builder, initializer,
                                      get_countries)
        expect { command.call(session, nil) }.to(
          publish(:ok, order: session_order, countries: countries)
        )
      end

      it 'with no order in session publishes :ok event '\
      'passing new initialized order and countries variables' do
        builder = double('BuildOrder', call: nil)
        command = described_class.new(get_totals, builder, initializer,
                                      get_countries)
        expect { command.call(session, nil) }.to(
          publish(:ok, order: initialized_order, countries: countries)
        )
      end
    end
  end
end
