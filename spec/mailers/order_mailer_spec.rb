describe Ecomm::OrderMailer, type: :mailer do
  let(:customer) { create(:member) }
  let(:order) do
    create(:raw_product)
    order = build(:order, customer: customer)
    order.line_items << build(:line_item, product_id: 1)
    order.shipment = build(:shipment)
    order.subtotal = 5.0
    order.save
    order
  end

  let(:order_email) { Ecomm::OrderMailer.order_email(order) }

  it 'after placing order sends confirmation email to user' do
    expect(order_email.to).to include(customer.email)
  end

  it 'has correct subject' do
    expect(order_email.subject).to include(
      t('ecomm.order_mailer.order_email.subject', number: order.decorate.number)
    )
  end

  it 'has link to order path in body' do
    expect(order_email.body.to_s).to include(order_path(order))
  end
end
