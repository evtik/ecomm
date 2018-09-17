shared_examples 'extended order details' do
  scenario 'has billing address caption' do
    expect(page).to have_css(
      'h3.general-subtitle',
      text: t('ecomm.checkout.address.billing_address')
    )
  end

  scenario 'has shipping address' do
    expect(page).to have_css(
      'h3.general-subtitle',
      text: t('ecomm.checkout.address.shipping_address')
    )
    expect(page).to have_css('p.general-address', text: 'Spain')
  end

  scenario 'has shipment' do
    expect(page).to have_css(
      'h3.general-subtitle',
      text: t('ecomm.checkout.shipments')
    )
    expect(page).to have_content('Delivery method #')
  end

  scenario 'has payment info' do
    expect(page).to have_css(
      'h3.general-subtitle',
      text: t('ecomm.checkout.payment_info')
    )
    expect(page).to have_content('** ** ** 4647')
  end
end
