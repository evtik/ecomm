FactoryBot.define do
  factory :shipment, class: 'Ecomm::Shipment' do
    sequence(:shipping_method) { |n| "Delivery method ##{n}" }
    sequence(:days_min) { |n| n * 1 }
    sequence(:days_max) { |n| n * 6 }
    price { Money.new(500) }
  end
end
