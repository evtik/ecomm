module Ecomm
  class CardLuhnValidator < ActiveModel::Validator
    def validate(record)
      return if record.number.blank? || luhn_valid?(record.number)
      record.errors[:number].push(
        I18n.t(
          'activemodel.errors.models.credit_card.attributes.number.luhn_invalid'
        )
      )
    end

    private

    def digits_of(number)
      number.split('').map(&:to_i).reverse
    end

    def luhn_valid?(number)
      odds, evens = digits_of(number).partition.with_index { |_el, i| i.even? }
      total = odds.reduce(:+)
      evens.each { |digit| total += digits_of((digit * 2).to_s).reduce(:+) }
      (total % 10).zero?
    end
  end
end
