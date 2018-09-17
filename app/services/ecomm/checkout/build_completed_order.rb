module Ecomm
  module Checkout
    class BuildCompletedOrder < BaseService
      pattr_initialize :addresses_builder, :line_items_builder

      def self.build
        new(Ecomm::Checkout::BuildOrderAddresses.build,
            Ecomm::Common::BuildLineItemsFromCart.build)
      end

      def call(session, customer_id)
        order_hash = session[:order].attributes.deep_stringify_keys
        Order.new(customer_id: customer_id,
                  coupon_id: session[:coupon_id],
                  shipment_id: order_hash['shipment_id'],
                  subtotal: order_hash['subtotal']).tap do |order|
          order.addresses = addresses_builder.call(order_hash)
          order.credit_card = CreditCard.new(order_hash['card'].attributes)
          order.line_items = line_items_builder.call(session[:cart])
        end
      end
    end
  end
end
