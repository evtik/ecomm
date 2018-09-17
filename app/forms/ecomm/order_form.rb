module Ecomm
  class OrderForm < Rectify::Form
    attribute(:use_billing, Boolean)
    attribute(:billing, AddressForm)
    attribute(:shipping, AddressForm)
    attribute(:shipment_id, Integer)
    attribute(:card, CreditCardForm)
    attribute(:credit_card, CreditCard)
    attribute(:items_total, Money)
    attribute(:subtotal, Money)
    attribute(:shipment, ShipmentForm)

    def addresses_valid?
      [billing.valid?, use_billing ? true : shipping.valid?].all?
    end
  end
end
