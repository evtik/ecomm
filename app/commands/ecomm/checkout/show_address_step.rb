module Ecomm
  module Checkout
    class ShowAddressStep < BaseCommand
      pattr_initialize :get_cart_totals, :order_builder, :order_initializer

      def self.build
        new(Ecomm::Cart::CalculateCartTotals.build,
            Ecomm::Checkout::BuildOrder.build,
            Ecomm::Checkout::InitializeOrder.build)
      end

      def call(session, _flash, customer_id)
        return publish(:denied, cart_path) if session[:cart].blank?
        totals = get_cart_totals.call(session)
        session[:items_total], session[:order_subtotal] = totals
        publish(:ok,
                order: order_builder.call(session) ||
                       order_initializer.call(session, customer_id))
      end
    end
  end
end
