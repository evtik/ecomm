Rails.application.routes.draw do
  devise_for :members
  root to: 'home#index'

  get 'home/index'
  resources :orders, only: :show

  mount Ecomm::Engine => '/ecomm'
end
