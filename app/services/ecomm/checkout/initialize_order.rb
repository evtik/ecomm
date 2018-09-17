module Ecomm
  module Checkout
    class InitializeOrder < BaseService
      pattr_initialize :get_or_create_address

      def self.build
        new(Ecomm::Common::GetOrCreateAddress.build)
      end

      def call(session, customer_id)
        OrderForm.new(
          billing: get_or_create_address.call(session, 'billing', customer_id),
          shipping: get_or_create_address.call(session, 'shipping',
                                               customer_id),
          items_total: session[:items_total],
          subtotal: session[:order_subtotal]
        ).tap { |order| session[:order] = order }
      end
    end
  end
end
