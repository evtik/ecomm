module Ecomm
  class CardExpiryValidator < ActiveModel::Validator
    def validate(record)
      tr_prefix = 'activemodel.errors.models.credit_card.attributes.month_year.'
      month, year = record.month_year.split('/')
      expiry = DateTime.new(('20' << year).to_i, month.to_i)
      return if expiry >= DateTime.now.beginning_of_month
      record.errors[:month_year] << I18n.t("#{tr_prefix}past_date")
    rescue
      record.errors[:month_year] << I18n.t("#{tr_prefix}invalid")
    end
  end
end
