module Ecomm
  module Checkout
    class SubmitPaymentStep < BaseCommand
      pattr_initialize :order_updater

      def self.build
        new(Ecomm::Checkout::UpdateOrder.build)
      end

      def call(session, params, *_args)
        order = order_updater.call(session, params.require(:order).permit!.to_h)
        return publish(:ok, checkout_confirm_path) if order&.card&.valid?
        publish(:error, checkout_payment_path)
      end
    end
  end
end
