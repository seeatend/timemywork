Rails.application.routes.draw do
  
  resources :members
  devise_for :admins
  root 'welcome#dashboard'
  devise_for :users  
  resources :users
  resources :customers
  resources :orders
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
