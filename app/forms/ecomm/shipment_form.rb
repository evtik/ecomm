module Ecomm
  class ShipmentForm < Rectify::Form
    attribute(:shipping_method, String)
    attribute(:days_min, Integer)
    attribute(:days_max, Integer)
    attribute(:price, Money)

    def price=(value)
      money_value = Money.new(value.to_d * 100) if value.instance_of?(String)
      super(money_value || value)
    end
  end
end
