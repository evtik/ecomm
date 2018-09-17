module Ecomm
  class CustomerOrders < Rectify::Query
    pattr_initialize :customer_id

    def query
      Order.where(customer_id: customer_id)
           .order('ecomm_orders.created_at DESC')
           .includes(:billing_address, :credit_card, :shipment, :coupon,
                     line_items: [:product])
    end
  end
end
