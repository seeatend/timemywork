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
    params = {"app_id" => "5eb5a37e-b458-11e3-ac11-000c2940e62c", 
              "contents" => {"en" => "English Message"},
              "included_segments" => ["All"]}
    uri = URI.parse('https://onesignal.com/api/v1/notifications')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path,
                                  'Content-Type'  => 'application/json;charset=utf-8',
                                  'Authorization' => "Basic NGEwMGZmMjItY2NkNy0xMWUzLTk5ZDUtMDAwYzI5NDBlNjJj")
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