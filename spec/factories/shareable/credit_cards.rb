FactoryBot.define do
  factory :credit_card, class: 'Ecomm::CreditCard' do
    number '4149625323094647'
    cardholder 'Marcellus Wallace'
    month_year '12/20'
    cvv '1234'
  end
end
