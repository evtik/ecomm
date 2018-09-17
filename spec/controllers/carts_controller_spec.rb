describe Ecomm::CartsController, type: :controller do
  routes { Ecomm::Engine.routes }

  describe 'GET show' do
    it 'renders :show template' do
      get :show
      expect(response).to render_template(:show)
    end

    it 'assigns order total variables' do
      create_list(:raw_product, 3)
      get :show, session: { cart: { 1 => 1, 2 => 2, 3 => 3 } }
      expect(assigns(:items_total)).to be_truthy
      expect(assigns(:discount)).to be_truthy
      expect(assigns(:order_subtotal)).to be_truthy
    end
  end

  describe 'PUT update' do
    shared_examples 'redirects' do
      it 'redirects back to cart' do
        put :update, params: params
        expect(response).to redirect_to(cart_path)
      end

      it "redirects to checkout address step if 'Checkout' was clicked" do
        put :update, params: params.merge(to_checkout: 1)
        expect(response).to redirect_to(checkout_address_path)
      end
    end

    context 'quantities' do
      let(:params) { { quantities: { 1 => 4, 2 => 5, 3 => 6 } } }

      before do
        session[:cart] = { '1' => 1, '2' => 2, '3' => 3 }
      end

      it 'updates book quantities in cart' do
        put :update, params: params
        expect(session[:cart]['1']).to eq(4)
        expect(session[:cart]['2']).to eq(5)
        expect(session[:cart]['3']).to eq(6)
      end

      include_examples 'redirects'
    end

    context 'coupon' do
      before do
        create(:coupon)
        session[:cart] = { '1' => 1, '2' => 2, '3' => 3 }
      end

      context 'with valid coupon code' do
        let(:params) do
          {
            quantities: { 1 => 1, 2 => 2, 3 => 3 },
            coupon: '123456'
          }
        end

        it 'assigns order discount' do
          put :update, params: params
          expect(session[:coupon_id]).to eq(1)
          expect(session[:discount]).to eq(10)
        end

        include_examples 'redirects'
      end

      context 'with invalid coupon code' do
        let(:params) do
          {
            quantities: { 1 => 1, 2 => 2, 3 => 3 },
            coupon: '222222'
          }
        end

        it 'assigns no discount' do
          expect(session[:coupon_id]).to be_nil
          expect(session[:discount]).to be_nil
        end

        include_examples 'redirects'
      end
    end
  end
end
