module Ecomm
  class CartItemsController < ApplicationController
    def create
      product_id = params[:id]
      quantity = params[:quantity].present? ? params[:quantity].to_i : 1
      session[:cart][product_id] ||= 0
      session[:cart][product_id] += quantity
      flash.keep
      redirect_back(fallback_location: main_app.root_path)
    end

    def destroy
      session[:cart].except!(params[:id])
      redirect_to(cart_path)
    end
  end
end
