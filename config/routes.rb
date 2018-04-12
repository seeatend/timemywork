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
  get '/order/new/' => 'orders#admin_new', :as => 'admin_new'
  get '/notify' => 'welcome#notify', :as => 'notify'
  get '/test' => 'welcome#test', :as => 'test'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
