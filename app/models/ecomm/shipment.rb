module Ecomm
  class Shipment < ApplicationRecord
    has_many :orders
  end
end
