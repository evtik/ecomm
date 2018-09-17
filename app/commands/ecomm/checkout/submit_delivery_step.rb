module Ecomm
  module Checkout
    class SubmitDeliveryStep < BaseCommand
      pattr_initialize :order_updater

      def self.build
        new(Ecomm::Checkout::UpdateOrder.build)
      end

      def call(session, params, *_args)
        order = order_updater.call(session, params.permit!.to_h)
        return publish(:ok, checkout_payment_path) if order&.shipment
        publish(:error, checkout_delivery_path)
      end
    end
  end
end
