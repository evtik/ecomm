module Ecomm
  module Checkout
    class ShowPaymentStep < BaseCommand
      pattr_initialize :order_builder

      def self.build
        new(Ecomm::Checkout::BuildOrder.build)
      end

      def call(session, *_args)
        order = order_builder.call(session)
        return publish(:denied, checkout_delivery_path) if order&.shipment.blank?
        order.card ||= CreditCardForm.new
        publish(:ok, order: order)
      end
    end
  end
end
