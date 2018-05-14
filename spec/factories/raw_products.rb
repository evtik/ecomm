FactoryBot.define do
  factory :raw_product do
    name { Faker::Ancient.god }
    desc { Faker::Hipster.paragraph(5, false, 10) }
    cost 55.95
  end
end
