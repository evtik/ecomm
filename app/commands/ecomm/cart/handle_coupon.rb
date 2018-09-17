module Ecomm
  module Cart
    class HandleCoupon < BaseCommand
      pattr_initialize :get_coupon_error

      def self.build
        new(Ecomm::Cart::GetCouponError.build)
      end

      def call(coupon_code)
        coupon = Coupon.includes(:order).find_by(code: coupon_code)
        coupon_states = coupon.present? ? [true, coupon.order.blank?] : [false]
        coupon_states << (coupon.expires >= Date.today) if coupon_states.all?
        return publish(:ok, coupon) if coupon_states.all?
        publish(:error, get_coupon_error.call(coupon_states))
      end
    end
  end
end
