shared_examples 'order details' do
  scenario 'has billing address country' do
    expect(page).to have_css('p.general-address', text: 'Italy')
  end

  scenario 'has books list' do
    products.each do |product|
      expect(page).to have_css('p.general-title', text: product.title)
    end
  end

  scenario 'has totals and shipment' do
    expect(page).to have_css('p.font-16', text: '5.40')
    expect(page).to have_css('p#shipment-label', text: '5.00')
    expect(page).to have_css('strong#order-total-label', text: '10.40')
  end

  scenario 'has no input controls' do
    expect(page).to_not have_css('a.close.general-cart-close')
    expect(page).to_not have_css("input[type='text']")
    expect(page).to_not have_css('.quantity_increment')
    expect(page).to_not have_css('.quantity_decrement')
  end
end
