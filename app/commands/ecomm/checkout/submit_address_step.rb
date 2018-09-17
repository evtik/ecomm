module Ecomm
  module Checkout
    class SubmitAddressStep < BaseCommand
      pattr_initialize :order_updater

      def self.build
        new(Ecomm::Checkout::UpdateOrder.build)
      end

      def call(session, params, *_args)
        order = order_updater.call(session, params.require(:order).permit!.to_h)
        return publish(:ok, checkout_delivery_path) if order&.addresses_valid?
        publish(:error, checkout_address_path)
      end
    end
  end
end
