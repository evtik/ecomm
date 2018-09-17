feature 'Checkout complete page' do
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit ecomm.checkout_complete_path
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with logged in user' do
    given!(:member) { create(:member) }
    given!(:products) { create_list(:raw_product, 3) }
    given!(:shipment) { create(:shipment) }
    given(:subtotal) { Money.new(540) }
    given (:order) do
      order = Ecomm::OrderForm.from_model(build(:order))
      order.billing = Ecomm::AddressForm.from_model(build(:address))
      order.shipping = Ecomm::AddressForm.from_model(
        build(:address, address_type: 'shipping')
      )
      order.shipment = Ecomm::ShipmentForm.from_model(shipment)
      order.shipment_id = 1
      order.card = Ecomm::CreditCardForm.from_model(build(:credit_card))
      order.subtotal = subtotal
      order
    end

    background do
      page.set_rack_session(cart: { 1 => 1, 2 => 2, 3 => 3 }, order: order,
                            order_subtotal: subtotal)
      login_as(member, scope: :member)
      visit ecomm.checkout_confirm_path
      click_on(t('ecomm.checkout.confirm.place_order'))
    end

    include_examples 'order details'

    scenario 'has 5 as current checkout progress step' do
      expect(page).to have_css('li.step.done', count: 4)
      expect(page).to have_css('li.step.active span.step-number', text: '5')
    end

    scenario 'has thanks message' do
      expect(page).to have_css(
        'h3.general-subtitle', text: t('ecomm.checkout.complete.thanks')
      )
    end

    scenario 'has email sent message' do
      expect(page).to have_css(
        'p.font-weight-light', text: member.email
      )
    end

    scenario 'has order number set' do
      expect(page).to have_css('p.general-order-number', text: '#R00000001')
    end

    scenario 'has no address edit link' do
      expect(page).not_to have_link('edit', href: ecomm.checkout_address_path)
    end

    scenario 'click back to store goes to catalog index' do
      click_on(t('ecomm.checkout.complete.back_to_store'))
      expect(page).to have_css('h1', text: 'Home#index')
    end
  end
end
