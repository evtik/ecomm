module Ecomm
  module Common
    class GetOrCreateAddress < BaseService
      pattr_initialize :get_address_from_session

      def self.build
        new(Ecomm::Checkout::GetAddressFromSession)
      end

      def call(session, address_type, customer_id)
        address_exists = session[:address] &&
                         session[:address]['address_type'] == address_type
        return get_address_from_session.call(session) if address_exists
        address = Address.find_by(customer_id: customer_id,
                                  address_type: address_type)
        return AddressForm.from_model(address) if address
        AddressForm.new(address_type: address_type)
      end
    end
  end
end
