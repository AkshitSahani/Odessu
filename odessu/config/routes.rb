Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'products#index'
  resources :users
  resources :stores
  resources :orders do
    resources :order_reviews
  end
  resources :products
  resources :wish_lists
  resources :conversations
  resources :messages
  resources :order_items
  resource :cart

  mount ActionCable.server => '/cable'
end
