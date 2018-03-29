Rails.application.routes.draw do
  
  resources :members
  devise_for :admins
  root 'welcome#dashboard'
  #devise_for :users  
  resources :users
  resources :customers
  resources :orders
  resources :products
  resources :creditors
  put '/creditors/:id/paid' => 'creditors#paid_credits', :as => 'paid_credits'

  get '/orders/admin-edit/:id' => 'orders#admin_edit', :as => 'admin_edit'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
