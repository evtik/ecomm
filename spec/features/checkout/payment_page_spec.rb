require_relative '../../support/forms/new_credit_card_form'

feature 'Checkout payment page' do
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit ecomm.checkout_payment_path
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with logged in user' do
    around do |example|
      login_as(create(:member), scope: :member)
      page.set_rack_session(order: Ecomm::OrderForm.new,
                            order_subtotal: Money.new(1200))
      example.run
      page.set_rack_session(order: nil)
    end

    context 'with no shipment set' do
      scenario 'redirects to checkout delivery step' do
        create_list(:shipment, 3)
        visit ecomm.checkout_payment_path
        expect(page).to have_css(
          'h3.general-subtitle',
          text: t('ecomm.checkout.delivery.shipping_method')
        )
      end
    end

    context 'with shipment set' do
      given (:order) do
        order = Ecomm::OrderForm.from_model(build(:order))
        order.shipment = Ecomm::ShipmentForm.from_params(price: '5.0')
        order
      end

      background do
        page.set_rack_session(order: order, order_subtotal: Money.new(2000))
      end

      scenario 'has 3 as current checkout progress step' do
        visit ecomm.checkout_payment_path
        expect(page).to have_css('li.step.done', count: 2)
        expect(page).to have_css('li.step.active span.step-number', text: '3')
      end

      scenario 'has credit card header' do
        visit ecomm.checkout_payment_path
        expect(page).to have_css(
          'h3.general-subtitle',
          text: t('ecomm.checkout.payment.credit_card')
        )
      end

      scenario 'has correct totals and shipment price' do
        visit ecomm.checkout_payment_path
        expect(page).to have_css('p.font-16', text: '20.00')
        expect(page).to have_css('p#shipment-label', text: '5.00')
        expect(page).to have_css('strong#order-total-label', text: '25.00')
      end

      context 'filling in credit card' do
        given(:credit_card_form) { NewCreditCardForm.new }

        background { order.subtotal = Money.new(3000) }

        scenario 'with valid data proceeds to confirm step' do
          create_list(:raw_product, 3)
          order.billing = Ecomm::AddressForm.from_model(build(:address))
          order.shipping = Ecomm::AddressForm.from_model(
            build(:address, address_type: 'shipping')
          )
          page.set_rack_session(cart: { 1 => 1, 2 => 2, 3 => 3 }, order: order)
          visit ecomm.checkout_payment_path
          credit_card_form.fill_in_with(attributes_for(:credit_card)).submit
          expect(page).to have_button(t('ecomm.checkout.confirm.place_order'))
        end

        scenario 'with invalid data shows errors' do
          page.set_rack_session(order: order)
          visit ecomm.checkout_payment_path
          credit_card_form.fill_in_with(
            attributes_for(:credit_card, number: '1234567891011121')
          ).submit
          tr_key = 'activemodel.errors.models.credit_card' \
            '.attributes.number.luhn_invalid'
          expect(page).to have_content(t(tr_key))
        end
      end
    end
  end
end
