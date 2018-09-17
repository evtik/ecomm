module Ecomm
  class CartsController < Ecomm::ApplicationController
    def show
      @line_items = Ecomm::Common::BuildLineItemsFromCart.call(session[:cart])
      totals = Ecomm::Cart::CalculateCartTotals.call(session)
      @items_total, @order_subtotal, @discount = totals
      session[:items_total] = @items_total
      session[:order_subtotal] = @order_subtotal
    end

    def update
      params[:quantities].each do |product_id, quantity|
        session[:cart][product_id] = quantity.present? ? quantity.to_i : 1
      end

      handle_coupon if params[:coupon].present?

      redirect_to(params[:to_checkout] ? checkout_address_path : cart_path)
    end

    private

    def handle_coupon
      Ecomm::Cart::HandleCoupon.call(params[:coupon]) do
        on(:error) do |error_message|
          flash[:alert] = error_message
          flash.keep
        end

        on(:ok) do |coupon|
          session[:coupon_id] = coupon.id
          session[:discount] = coupon.discount
        end
      end
    end
  end
end
