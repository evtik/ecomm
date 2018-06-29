require_relative '../../../support/forms/new_address_form'

feature 'Checkout address page' do
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit ecomm.checkout_address_path
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with logged in user' do
    context 'with empty cart' do
      scenario 'redirects to cart page' do
        login_as(create(:member), scope: :member)
        visit ecomm.checkout_address_path
        expect(page).to have_content(
          t('ecomm.carts.show.cart_empty_html',
            href: (t 'ecomm.carts.show.catalog_caption'))
        )
      end
    end

    context 'with items in cart' do
      around do |example|
        login_as(create(:member), scope: :member)
        create_list(:raw_product, 3)
        page.set_rack_session(
          cart: { 1 => 1, 2 => 2, 3 => 3 },
          discount: 10
        )
        visit ecomm.checkout_address_path
        example.run
        page.set_rack_session(cart: nil, items_total: nil, order_subtotal: nil)
      end

      scenario 'has 1 as current checkout progress step' do
        expect(page).not_to have_css('li.step.done')
        expect(page).to have_css('li.step.active span.step-number', text: '1')
      end

      scenario 'has addresses headers' do
        expect(page).to have_css(
          'h3.general-subtitle',
          text: t('ecomm.checkout.address.billing_address')
        )
        expect(page).to have_css(
          'h3.general-subtitle',
          text: t('ecomm.checkout.address.shipping_address')
        )
      end

      scenario 'has correct totals' do
        expect(page).to have_css('p.font-16', text: '6.00')
        expect(page).to have_css('p.font-16', text: '5.40')
      end

      context 'filling in addresses', :include_translation_helpers do
        context 'billing' do
          given(:billing_address_form) do
            NewAddressForm.new('order', 'billing')
          end

          context 'with vaild data' do
            background do
              create_list(:shipment, 3)
              billing_address_form.fill_in_form(
                attributes_for(:address,
                               city: 'Billburg', country: 'Ukraine',
                               phone: '+1234567891011')
              )
            end

            context 'and empty shipping address' do
              scenario "shows 'empty' errors" do
                click_on(t('ecomm.checkout.save_continue'))
                expect(page).to have_content(
                  attr_blank_error(:address, :first_name)
                )
              end

              scenario "with 'use billing' checked goes to delivery page",
                       use_selenium: true do
                find('i.fa-check').click
                click_on(t('ecomm.checkout.save_continue'))
                expect(page).to have_css(
                  'h3.general-subtitle',
                  text: t('ecomm.checkout.delivery.shipping_method')
                )
              end
            end
          end

          context 'with invalid data' do
            scenario "shows some 'invalid format' errors" do
              billing_address_form.fill_in_form(
                attributes_for(:address, last_name: '#(*&@#')
              )
              click_on(t('ecomm.checkout.save_continue'))
              expect(page).to have_content(t('errors.messages.invalid'))
            end
          end

          context 'and shipping' do
            given(:shipping_address_form) do
              NewAddressForm.new('order', 'shipping')
            end

            scenario 'with valid data proceeds to delivery page' do
              create_list(:shipment, 3)
              billing_address_form.fill_in_form(
                attributes_for(:address,
                               city: 'Billburg', country: 'France',
                               phone: '+1234567891011')
              )
              shipping_address_form.fill_in_form(
                attributes_for(:address,
                               city: 'Shipburg', country: 'Spain',
                               phone: '+9876543219876')
              )
              click_on(t('ecomm.checkout.save_continue'))
              expect(page).to have_css(
                'h3.general-subtitle',
                text: t('ecomm.checkout.delivery.shipping_method')
              )
            end

            scenario 'with some invalid data shows errors' do
              billing_address_form.fill_in_form(
                attributes_for(:address, street_address: '(*&(*&')
              )
              shipping_address_form.fill_in_form(
                attributes_for(:address, city: '')
              )
              click_on(t('ecomm.checkout.save_continue'))
              expect(page).to have_content(t('errors.messages.invalid'))
              expect(page).to have_content(
                attr_blank_error(:address, :city)
              )
            end
          end
        end
      end
    end
  end
end
