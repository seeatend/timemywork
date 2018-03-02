class WelcomeController < ApplicationController
  before_action :authenticate_admin!
  layout false
  
  def dashboard
    @account = Account.first
    @orders = Order.all
    @users = Member.all
  end
  
  
end