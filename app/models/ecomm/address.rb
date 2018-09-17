module Ecomm
  class Address < ApplicationRecord
    belongs_to :customer, class_name: Ecomm.customer_class.to_s, optional: true
    belongs_to :order, optional: true

    scope :billing, -> { where(address_type: 'billing') }
    scope :shipping, -> { where(address_type: 'shipping') }
  end
end
