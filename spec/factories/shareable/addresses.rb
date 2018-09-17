FactoryBot.define do
  factory :address, class: 'Ecomm::Address' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    street_address { Faker::Address.street_address }
    city { Faker::Address.city.delete(' ') }
    zip { Faker::Address.zip }
    country 'Italy'
    phone { '+' << Faker::PhoneNumber.subscriber_number(10) }
    address_type 'billing'
  end
end
