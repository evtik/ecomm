module Ecomm
  class OrderMailer < ApplicationMailer
    def order_email(order)
      @customer = order.customer
      @order = order.decorate
      @line_items = @order.line_items
      mail(to: @customer.email,
           subject: default_i18n_subject(number: @order.number))
    end
  end
end
