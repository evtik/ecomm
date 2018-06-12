module Ecomm
  class CheckoutPresenter < Rectify::Presenter
    def steps
      CHECKOUT_STEPS
    end

    def previous?(step, action)
      CHECKOUT_STEPS.index(step) < CHECKOUT_STEPS.index(action.to_sym)
    end

    def current?(step, action)
      CHECKOUT_STEPS.index(step) == CHECKOUT_STEPS.index(action.to_sym)
    end
  end
end
