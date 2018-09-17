module Ecomm
  class CheckoutController < Ecomm::ApplicationController
    include Rectify::ControllerHelpers

    steps = Ecomm.checkout_steps

    before_action(:authenticate_customer)
    before_action(-> { present CheckoutPresenter.new }, only: steps)

    steps.each do |step|
      define_method(step) do
        command = "Ecomm::Checkout::Show#{step.capitalize}Step".constantize
        command.call(session, flash, current_customer.id) do
          on(:ok) { |step_variables| expose(step_variables) }
          on(:denied) { |failure_path| redirect_to(failure_path) }
        end
      end

      next if step == steps.last

      define_method("submit_#{step}") do
        command = "Ecomm::Checkout::Submit#{step.capitalize}Step".constantize
        command.call(session, params, flash, current_customer.id) do
          on(:ok) { |ok_path| redirect_to(ok_path) }
          on(:error) { |error_path| redirect_to(error_path) }
        end
      end
    end
  end
end
