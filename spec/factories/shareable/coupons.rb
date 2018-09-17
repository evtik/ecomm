FactoryBot.define do
  factory :coupon, class: 'Ecomm::Coupon' do
    code '123456'
    expires Date.today
    discount 10

    factory :coupon_with_order do
      after(:build) do |coupon|
        coupon.order = build(:order)
      end
    end
  end
end
