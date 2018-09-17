module Ecomm
  module Checkout
    class SubmitConfirmStep < BaseCommand
      pattr_initialize :order_builder, :mailer

      def self.build
        new(Ecomm::Checkout::BuildCompletedOrder.build, OrderMailer)
      end

      def call(session, _params, flash, customer_id)
        @order = order_builder.call(session, customer_id)
        @order.save ? handle_success(session, flash) : handle_error(flash)
      end

      private

      def handle_success(session, flash)
        %i(cart order discount coupon_id).each { |key| session.delete(key) }
        mailer.order_email(@order).deliver
      rescue StandardError => error
        Rails.logger.error(error.inspect)
      ensure
        flash[:order_confirmed] = true
        publish(:ok, checkout_complete_path)
      end

      def handle_error(flash)
        flash[:alert] = I18n.t(
          'ecomm.checkout.submit_confirm.order_placement_error'
        )
        publish(:error, checkout_confirm_path)
      end
    end
  end
end
