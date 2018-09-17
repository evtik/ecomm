module Ecomm
  module Checkout
    class BuildOrder < BaseService
      def call(session)
        order = session[:order]
        return if order.blank?
        order.items_total = session[:items_total]
        order.subtotal = session[:order_subtotal]
        order.tap(&:valid?)
      end
    end
  end
end
