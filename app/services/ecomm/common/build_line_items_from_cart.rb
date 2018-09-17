module Ecomm
  module Common
    class BuildLineItemsFromCart < BaseService
      def call(cart)
        cart.map do |product_id, quantity|
          LineItem.new do |line_item|
            line_item.product_id = product_id
            line_item.quantity = quantity.to_i
          end
        end
      end
    end
  end
end
