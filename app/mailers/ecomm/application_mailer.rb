module Ecomm
  class ApplicationMailer < ::ApplicationMailer
    include Ecomm::ApplicationHelper
    add_template_helper(Ecomm::ApplicationHelper)
  end
end
