module Ecomm
  class LineItem < ApplicationRecord
    belongs_to :product, class_name: Ecomm.product_class.to_s
    belongs_to :order
  end
end
