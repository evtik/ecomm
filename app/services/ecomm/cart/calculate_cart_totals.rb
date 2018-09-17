module Ecomm
  module Cart
    class CalculateCartTotals < BaseService
      def call(session)
        cart = session[:cart]
        cut = session[:discount]
        products = Ecomm.product_class.find(cart.keys)
        items_total = cart.values.each_with_index.sum do |quantity, index|
          quantity * products[index].price
        end
        discount = Money.new(cut ? (items_total * cut / 100) : 0)
        [items_total, items_total - discount, discount]
      end
    end
  end
end
