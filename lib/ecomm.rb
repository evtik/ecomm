require "ecomm/engine"

module Ecomm
  CHECKOUT_STEPS = [:address, :delivery, :payment, :confirm, :complete]

  mattr_accessor :customer_class, :product_class,
                 :current_customer_method, :completed_order_url_helper_method,
                 :flash_login_return_to, :flash_not_authenticated_message_key,
                 :signin_path, :back_to_store_path, :session_customer_id_key

  class << self
    def customer_class
      @@customer_class.constantize
    end

    def product_class
      @@product_class.constantize
    end

    def get_customer_id(session)
      eval <<-RUBY, binding, __FILE__, __LINE__ + 1
        session#{Ecomm.session_customer_id_key}
      RUBY
    end
  end
end
