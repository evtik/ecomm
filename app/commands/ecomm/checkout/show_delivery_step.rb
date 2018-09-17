module Ecomm
  module Checkout
    class ShowDeliveryStep < BaseCommand
      pattr_initialize :order_builder

      def self.build
        new(Ecomm::Checkout::BuildOrder.build)
      end

      def call(session, *_args)
        order = order_builder.call(session)
        return publish(:denied, checkout_address_path) if order.blank?
        shipments = Shipment.all
        if order.shipment.blank?
          order.shipment_id = shipments.first.id
          order.shipment = ShipmentForm.from_model(shipments.first)
        end
        publish(:ok, order: order, shipments: shipments)
      end
    end
  end
end
