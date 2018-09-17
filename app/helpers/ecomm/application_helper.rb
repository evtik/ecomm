module Ecomm
  module ApplicationHelper
    def completed_order_url(order)
      main_app.send(Ecomm.completed_order_url_helper_method, order)
    end
  end
end
