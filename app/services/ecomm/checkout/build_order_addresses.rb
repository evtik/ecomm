module Ecomm
  module Checkout
    class BuildOrderAddresses < BaseService
      def call(order)
        addresses = [Address.new(order['billing'].attributes.except!('id'))]
        return addresses if order['use_billing']
        addresses << Address.new(order['shipping'].attributes.except!('id'))
      end
    end
  end
end
