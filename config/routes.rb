Rails.application.routes.draw do

  root 'welcome#dashboard'
  resources :members
  devise_for :admins
  #devise_for :users
  resources :users
  resources :customers
  resources :orders
  resources :products
  resources :creditors
  resources :tokens, :only => [:create]
  put '/creditors/:id/paid' => 'creditors#paid_credits', :as => 'paid_credits'
  put '/orders/:id/paid' => 'orders#paid_company', :as => 'paid_company'
  put '/orders/:id/return' => 'orders#company_return', :as => 'company_return'
  get '/orders/admin-edit/:id' => 'orders#admin_edit', :as => 'admin_edit'
  get '/order/new/' => 'orders#admin_new', :as => 'admin_new'
  get '/notify' => 'welcome#notify', :as => 'notify'
  get '/test' => 'welcome#test', :as => 'test'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'orders/add_order'

end
