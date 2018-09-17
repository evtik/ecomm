module Ecomm
  class CreditCard < ApplicationRecord
    belongs_to :order
  end
end
