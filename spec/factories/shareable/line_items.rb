FactoryBot.define do
  factory :line_item, class: 'Ecomm::LineItem' do
    quantity 1
    ids = [*1..3]
    sequence(:product_id) { |n| ids[(n - 1) % ids.length] }

    factory :line_item_with_product_id_cycled do
      ids = [*1..4]
      sequence(:product_id) { |n| ids[(n - 1) % ids.length] }
    end
  end
end
