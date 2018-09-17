module Ecomm
  module Checkout
    class ShowConfirmStep < BaseCommand
      pattr_initialize :order_builder, :line_items_builder

      def self.build
        new(Checkout::BuildOrder.build,
            Ecomm::Common::BuildLineItemsFromCart.build)
      end

      def call(session, *_args)
        order = order_builder.call(session)
        return publish(:denied, checkout_payment_path) if order&.card.blank?
        order.credit_card = CreditCard.new(order.card.to_h)
        publish(
          :ok,
          order: order,
          billing: order.billing,
          shipping: order.use_billing ? order.billing : order.shipping,
          line_items: line_items_builder.call(session[:cart])
        )
      end
    end
  end
end
