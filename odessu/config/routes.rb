Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'products#index'
  devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions'}
  devise_scope :user do
    get '/profile_1', to: 'users/registrations#profile_1', as: 'profile_1'
    patch '/create_profile_1', to: 'users/registrations#create_profile_1', as: 'create_profile_1'
    get '/profile_2', to: 'users/registrations#profile_2', as: 'profile_2'
    patch '/create_profile_2', to: 'users/registrations#create_profile_2', as: 'create_profile_2'
    get '/profile_3', to: 'users/registrations#profile_3', as: 'profile_3'
    patch '/create_profile_3', to: 'users/registrations#create_profile_3', as: 'create_profile_3'
    get '/users/:id', to: 'users/registrations#show', as: 'user'
    get '/edit_profile', to: 'users/registrations#edit_profile', as: 'edit_profile'
    patch '/update_profile', to: 'users/registrations#update_profile', as: 'update_profile'
    put '/update_issues', to: 'users/registrations#update_issues', as: 'update_issues'
  end
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
  resources :issue

  mount ActionCable.server => '/cable'
end
