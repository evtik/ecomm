module Ecomm
  class Coupon < ApplicationRecord
    has_one :order
  end
end
