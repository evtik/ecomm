Ecomm::Engine.routes.draw do
  root to: 'carts#show'

  resource :cart, only: [:show, :update]
  resources :cart_items, only: [:create, :destroy]

  scope 'checkout' do
    Ecomm.checkout_steps.each do |action|
      get action, to: "checkout##{action}", as: "checkout_#{action}"

      next if action == Ecomm.checkout_steps.last

      post action, to: "checkout#submit_#{action}",
                   as: "checkout_submit_#{action}"
    end
  end
end
