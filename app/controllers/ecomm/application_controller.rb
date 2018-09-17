module Ecomm
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception
    helper_method :current_customer
    before_action { session[:cart] ||= Hash.new(0) }

    def current_customer
      public_send(Ecomm.current_customer_method)
    end

    private

    def authenticate_customer
      return if current_customer
      session[Ecomm.flash_login_return_to] = request.fullpath
      flash.alert = t(Ecomm.i18n_unuathenticated_key)
      redirect_to(Ecomm.signin_path)
    end
  end
end
