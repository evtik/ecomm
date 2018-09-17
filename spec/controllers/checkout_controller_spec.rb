describe Ecomm::CheckoutController, type: :controller do
  routes { Ecomm::Engine.routes }

  context 'logged in user' do
    let(:member) { create(:member) }
    let(:order) { Ecomm::OrderForm.new }

    before { sign_in(member) }

    context 'GET address' do
      before do
        create_list(:raw_product, 3)
      end

      it 'renders :address template' do
        get :address, session: { cart: { 1 => 1, 2 => 2, 3 => 3 } }
        expect(response).to render_template(:address)
      end

      it 'assigns values to instance variables' do
        get :address, session: {
          cart: { 1 => 1, 2 => 2, 3 => 3 },
          discount: 10
        }
        order = assigns(:order)
        expect(order).to be_truthy
        expect(order.billing).to be_truthy
        expect(order.shipping).to be_truthy
        expect(order.items_total.cents).to eq(600)
        expect(order.subtotal.cents).to eq(540)
      end
    end

    context 'POST submit_address' do
      it 'with valid data redirects to checkout#delivery' do
        post :submit_address, params: {
          order: {
            billing: attributes_for(:address, address_type: 'billing'),
            shipping: attributes_for(:address, address_type: 'shipping')
          }
        }, session: { order: order }
        expect(response).to redirect_to(checkout_delivery_path)
      end

      it 'with invalid data redirects back to checkout#address' do
        post :submit_address, params: {
          order: {
            billing: attributes_for(:address, address_type: 'billing',
                                              city: '2822'),
            shipping: attributes_for(:address, address_type: 'shipping')
          }
        }, session: { order: order }
        expect(response).to redirect_to(checkout_address_path)
      end
    end

    context 'GET delivery' do
      let!(:shipments) { create_list(:shipment, 3) }

      it 'renders :delivery template' do
        get :delivery, session: { order: order }
        expect(response).to render_template(:delivery)
      end

      it 'assigns shipment to @order' do
        get :delivery, session: { order: order }
        order = assigns(:order)
        expect(order.shipment_id).to eq(1)
        expect(order.shipment.shipping_method).to eq(
          shipments.first.shipping_method
        )
      end
    end

    context 'POST submit_delivery' do
      it 'with shipment present redirects to checkout#payment' do
        post :submit_delivery,
             params: { shipment: attributes_for(:shipment) },
             session: { order: order }
        expect(response).to redirect_to(checkout_payment_path)
      end

      it 'with no shipment redirects back to checkout#delivery' do
        post :submit_delivery, session: { order: order }
        expect(response).to redirect_to(checkout_delivery_path)
      end
    end

    context 'GET payment' do
      before do
        order = Ecomm::OrderForm.new
        order.shipment = Ecomm::ShipmentForm.from_model(build(:shipment))
        get :payment, session: { order: order}
      end

      it 'renders :payment template' do
        expect(response).to render_template(:payment)
      end

      it 'assigns value to @order.card' do
        expect(assigns(:order).card).to be_truthy
      end
    end

    context 'POST submit_payment' do
      it 'with valid payment data redirects to checkout#confirm' do
        post :submit_payment,
             params: { order: { card: attributes_for(:credit_card) } },
             session: { order: order }
        expect(response).to redirect_to(checkout_confirm_path)
      end

      it 'with invalid payment data redirects to checkout#payment' do
        invalid_card = attributes_for(:credit_card, cardholder: '234&lj@')
        post :submit_payment,
             params: { order: { card: invalid_card } },
             session: { order: order }
        expect(response).to redirect_to(checkout_payment_path)
      end
    end

    context 'confirm actions' do
      let(:order) do
        order = Ecomm::OrderForm.from_model(build(:order))
        order.billing = Ecomm::AddressForm.from_model(build(:address))
        order.shipping = Ecomm::AddressForm.from_model(
          build(:address, address_type: 'shipping')
        )
        order.shipment = Ecomm::ShipmentForm.from_model(build(:shipment))
        order.shipment_id = 1
        order.card = Ecomm::CreditCardForm.from_model(build(:credit_card))
        order.subtotal = Money.new(540)
        order
      end

      let(:session_data) { { cart: { 1 => 1, 2 => 2, 3 => 3 }, order: order } }

      context 'GET confirm' do
        before do
          get :confirm, session: session_data
        end

        it 'renders :confirm template' do
          expect(response).to render_template(:confirm)
        end

        it 'assigns value to @order' do
          expect(assigns(:order)).to be_truthy
        end
      end

      context 'POST submit_confirm' do
        before do
          create_list(:raw_product, 3)
          create(:shipment)
        end

        it 'redirects to checkout#complete' do
          post :submit_confirm, session: session_data
          expect(response).to redirect_to(checkout_complete_path)
        end

        it 'creates new order in db' do
          expect {
            post :submit_confirm, session: session_data
          }.to change(Ecomm::Order, :count).by(1)
        end

        it 'sends order confirmation email to customer' do
          post :submit_confirm, session: session_data
          expect(ActionMailer::Base.deliveries.last.to).to(
            include(member.email)
          )
        end
      end
    end

    context 'GET complete' do
      before do
        allow_any_instance_of(Ecomm::CheckoutController).to(
          receive(:flash).and_return(
            ActionDispatch::Flash::FlashHash.new(order_confirmed: true)
          )
        )
        create_list(:raw_product, 3)
        order = build(:order)
        order.line_items << build_list(:line_item, 3)
        order.addresses << build(:address)
        order.shipment = build(:shipment)
        order.credit_card = build(:credit_card)
        order.customer = member
        order.save
        get :complete
      end

      it 'renders :complete template' do
        expect(response).to render_template(:complete)
      end

      it 'assigns value to @order' do
        expect(assigns(:order)).to be_truthy
      end
    end
  end

  context 'guest user' do
    shared_examples 'not authenticated' do |verb, path|
      it 'redirects to login page' do
        send(verb, path)
        expect(response).to redirect_to(Ecomm.signin_path)
      end
    end

    context 'GET address' do
      include_examples('not authenticated', :get, :address)
    end

    context 'POST submit_address' do
      include_examples('not authenticated', :post, :submit_address)
    end

    context 'GET delivery' do
      include_examples('not authenticated', :get, :delivery)
    end

    context 'POST submit_delivery' do
      include_examples('not authenticated', :post, :submit_delivery)
    end

    context 'GET payment' do
      include_examples('not authenticated', :get, :payment)
    end

    context 'POST submit_payment' do
      include_examples('not authenticated', :post, :submit_payment)
    end

    context 'GET confirm' do
      include_examples('not authenticated', :get, :confirm)
    end

    context 'POST submit_confirm' do
      include_examples('not authenticated', :post, :submit_confirm)
    end

    context 'GET complete' do
      include_examples('not authenticated', :get, :complete)
    end
  end
end
