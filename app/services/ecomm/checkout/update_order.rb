module Ecomm
  module Checkout
    class UpdateOrder < BaseService
      def call(session, order_params)
        order_hash = session[:order].attributes.deep_stringify_keys
        OrderForm.from_params(order_hash.merge(order_params))
                 .tap do |order|
                   order.card.number.delete!('-') if order.card.present?
                   session[:order] = order
                 end
      end
    end
  end
end
