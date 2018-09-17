FactoryBot.define do
  factory :order, class: 'Ecomm::Order' do
    after(:build) do |order|
      order.shipment = build(:shipment)
    end
  end
end
