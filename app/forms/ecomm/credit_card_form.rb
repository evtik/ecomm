module Ecomm
  class CreditCardForm < Rectify::Form
    fields = {
      number: /\A\d{16}\z/,
      cardholder: /\A[A-Za-z]+(\s[A-Za-z]+)*\z/,
      month_year: /\A\d{2}\/\d{2}\z/,
      cvv: /\A\d{3,4}\z/
    }

    fields.each do |field, format|
      attribute(field, String)
      validates(field, presence: true, format: { with: format })
    end

    validates_with(CardLuhnValidator, CardExpiryValidator)
  end
end
