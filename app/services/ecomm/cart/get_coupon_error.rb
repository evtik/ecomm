module Ecomm
  module Cart
    class GetCouponError < BaseService
      include AbstractController::Translation

      def call(coupon_states)
        {
          [false] => t('ecomm.coupon.non_existent'),
          [true, false] => t('ecomm.coupon.taken'),
          [true, true, false] => t('ecomm.coupon.expired')
        }[coupon_states]
      end
    end
  end
end
