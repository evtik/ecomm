FactoryBot.define do
  factory :member, class: Member do
    email { Faker::Internet.email }
    password '11111111'
    password_confirmation '11111111'

    factory :member_with_address do
      after(:build) do |member|
        member.addresses << build(:address)
      end
    end
  end
end
