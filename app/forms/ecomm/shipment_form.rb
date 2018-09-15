module Ecomm
  class ShipmentForm < Rectify::Form
    attribute(:shipping_method, String)
    attribute(:days_min, Integer)
    attribute(:days_max, Integer)
    attribute(:price, Decimal)
  end
end
