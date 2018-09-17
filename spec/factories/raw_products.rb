FactoryBot.define do
  factory :raw_product, class: RawProduct do
    name { Faker::Ancient.god }
    desc { Faker::Hipster.paragraph(5, false, 10) }
    cost { Money.new(100) }
    image do
      Rack::Test::UploadedFile.new(
        File.join(Rails.root, '..', 'fixtures', '16.png'), 'image/png'
      )
    end
  end
end
