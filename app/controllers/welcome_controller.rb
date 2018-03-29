class WelcomeController < ApplicationController
  before_action :authenticate_admin!
  before_action :must_be_admin
  layout false
  
  def dashboard
    @account = Account.first
    @orders = Order.all
    @users = Member.all
  end
  
  def notify
    require 'net/http'
    
    params = {"app_id" => "e890308e-4333-4497-b7b6-59ae47145896", 
              "contents" => {"en" => "English Message"},
              "included_segments" => ["All"]}
    uri = URI.parse('https://onesignal.com/api/v1/notifications')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path,
                                  'Content-Type'  => 'application/json;charset=utf-8',
                                  'Authorization' => "Basic MjE4MWRlNWMtODJmMi00NWQ0LTk2OTctNjg3ZmU0N2I5ZTAw")
    request.body = params.as_json.to_json
    response = http.request(request) 
    puts response.body
  end
  
  private 
  
  def must_be_admin
    unless current_admin && current_admin.user_type == "admin"
      redirect_to new_order_path
    end

    
  end
  
end