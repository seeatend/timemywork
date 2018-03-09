class WelcomeController < ApplicationController
  before_action :authenticate_admin!
  before_action :must_be_admin
  layout false
  
  def dashboard
    @account = Account.first
    @orders = Order.all
    @users = Member.all
  end
  
  
  private 
  
  def must_be_admin
    unless current_admin && current_admin.user_type == "admin"
      redirect_to new_order_path
    end

    
  end
  
end