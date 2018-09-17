module Ecomm
  class Order < ApplicationRecord
    belongs_to :customer, optional: true, class_name: Ecomm.customer_class.to_s
    belongs_to :coupon, optional: true
    belongs_to :shipment
    has_many :line_items, dependent: :destroy
    has_many :addresses, dependent: :destroy
    has_one :billing_address, -> { billing }, class_name: 'Ecomm::Address'
    has_one :shipping_address, -> { shipping }, class_name: 'Ecomm::Address'
    has_one :credit_card, dependent: :destroy

    monetize :subtotal_cents
  end
end
