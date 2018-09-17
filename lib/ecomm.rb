require 'ecomm/engine'

module Ecomm
  mattr_accessor :checkout_steps, :customer_class, :product_class,
                 :current_customer_method, :signin_path,
                 :flash_login_return_to, :i18n_unuathenticated_key,
                 :catalog_path, :completed_order_url_helper_method

  @@checkout_steps = [:address, :delivery, :payment, :confirm, :complete]

  class << self
    def customer_class
      @@customer_class.constantize
    end

    def product_class
      @@product_class.constantize
    end

    def setup
      yield self
    end
  end
end
