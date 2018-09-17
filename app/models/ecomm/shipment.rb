module Ecomm
  class Shipment < ApplicationRecord
    has_many :orders
    monetize :price_cents
  end
end
