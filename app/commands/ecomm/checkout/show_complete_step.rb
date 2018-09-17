module Ecomm
  module Checkout
    class ShowCompleteStep < BaseCommand
      pattr_initialize :customer_orders

      def self.build
        new(Ecomm::CustomerOrders)
      end

      def call(_session, flash, customer_id)
        return publish(:denied, cart_path) unless flash[:order_confirmed]
        flash.keep
        order = customer_orders.new(customer_id).first.decorate
        publish(:ok, order: order, line_items: order.line_items)
      end
    end
  end
end
