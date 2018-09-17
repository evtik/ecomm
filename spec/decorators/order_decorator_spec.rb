describe Ecomm::OrderDecorator do
  it '#number returns order id in unified format' do
    order = create(:order).decorate
    expect(order.number).to eq('R00000001')
  end
end
