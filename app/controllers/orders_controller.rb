require 'sendgrid-ruby'
include SendGrid

class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]
  before_action :pending_order, only: [:new]
  

  # GET /orders
  def index
    @orders = Order.all.order(endtime: :desc)
    
    respond_to do |format|

      format.html
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  def show
    render json: @order
  end
  
  def new
    @member = Member.new
    @order = Order.new
  end
  
  def edit
    @order = Order.find(params[:id])
  end
  
  def admin_edit
    @order = Order.find(params[:id])
  end
  
  def admin_new
    @order = Order.new
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    if params[:order][:member_id]
      @order.user_id = 1
      @order.member_id = params[:order][:member_id]
      member = Member.find(@order.member_id)
    else
      @order.user_id = 1
      @order.member_id = current_admin.member_id
      member = current_admin.member
    end
    if params[:order][:job_type] == "Fixed"
      @order.amount = member.fixed_rate
      if params[:order][:fixed_type] == "Hotel"
        @order.cost = member.hotel_fixed_cost
      else
        @order.cost = member.normal_fixed_cost
      end
    end
    
    if params[:order][:job_type] == "Time Tracking"
      @order.amount = member.time_rate
      @order.cost = member.time_cost
      if params[:order][:endtime]
        @order.amount = @order.amount * ((params[:order][:endtime].to_time - params[:order][:starttime].to_time) / 1.hours).round(0.1)
        @order.cost = @order.cost * ((params[:order][:endtime].to_time - params[:order][:starttime].to_time) / 1.hours).round(0.1)
      end
    end
    if params[:order][:job_type] == "Day"
      @order.amount = member.day_rate
      @order.cost = member.day_cost
    end
    if params[:order][:job_type] == "O.N"
      @order.amount = member.night_rate
      @order.cost = member.night_cost
    end
    unless params[:order][:starttime]
      @order.starttime = DateTime.now
    end


    if @order.save
      
      if params[:order][:member_id]
        if @order.status == "Credit"
          credit = @order.build_credit(name: @order.creditor_name, amount: @order.amount, status: "Unpaid")
          credit.save
        end
          Account.first.update(sales: Account.first.sales + @order.amount)
          Account.first.update(costs: Account.first.costs + @order.cost)
      
          respond_to do |format|

            format.html {redirect_to admin_new_path(@order)}# show.html.erb
            format.json { render json: @order, status: :created, location: @order }
          end
          
      else
        
      require 'net/http'
      message = @order.get_user_name + " has start a job!"
      params = {"app_id" => "e890308e-4333-4497-b7b6-59ae47145896", 
                "contents" => {"en" => message},
                "included_segments" => ["All"]}
      uri = URI.parse('https://onesignal.com/api/v1/notifications')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.path,
                                    'Content-Type'  => 'application/json;charset=utf-8',
                                    'Authorization' => "Basic MjE4MWRlNWMtODJmMi00NWQ0LTk2OTctNjg3ZmU0N2I5ZTAw")
      request.body = params.as_json.to_json
      http.request(request)
      
      

      from = Email.new(email: 'admin@ysl.com')
      to = Email.new(email: 'yslysl8888@gmail.com')
      subject = @order.get_user_name + ' has start a job!'
      content = Content.new(type: 'text/plain', value: 'Job Type: ' + @order.job_type)
      mail = Sendgrid::Mail.new(from, subject, to, content)
      puts "EMAIL HERE"
      sg = SendGrid::API.new(api_key: "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")
      response = sg.client.mail._('send').post(request_body: mail.to_json)
      puts response
      
      respond_to do |format|

        format.html {redirect_to edit_order_path(@order)}# show.html.erb
        format.json { render json: @order, status: :created, location: @order }
      end
    end
      
    else
      respond_to do |format|

        format.html {redirect_to new_order_path(@order)}# show.html.erb
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.endtime == nil
      @order.endtime = DateTime.now
    end
    
    unless params[:order][:amount].present?
      if @order.job_type == "Time Tracking"
        
        @order.amount = @order.amount * ((@order.endtime.to_time - @order.starttime.to_time) / 1.hours).round(0.1)
        @order.cost = @order.cost * ((@order.endtime.to_time - @order.starttime.to_time) / 1.hours).round(0.1)
      end
    else
      @amount = @order.amount
      @cost = @order.cost
    end
      
    if @order.update(order_params)
      
      if params[:order][:amount].present?
        puts "EXIST"
        if @order.status == "Credit"
          if @order.credit
            @order.credit.update(amount: @order.amount, name: @order.creditor_name)
          else
            credit = @order.build_credit(name: @order.creditor_name, amount: @order.amount, status: "Unpaid")
            credit.save
          end
        end
        sales = Account.first.sales - @amount + @order.amount
        costs = Account.first.costs - @cost + @order.cost
        Account.first.update(sales: sales, costs: costs)
        respond_to do |format|
          format.html {redirect_to admin_edit_path(@order)}# show.html.erb
          format.json { render json: @order }
        end
      else
        puts "NOT EXIST"
        require 'net/http'
        message = @order.get_user_name + " has ended a job!"
        params = {"app_id" => "e890308e-4333-4497-b7b6-59ae47145896", 
                  "contents" => {"en" => message},
                  "included_segments" => ["All"]}
        uri = URI.parse('https://onesignal.com/api/v1/notifications')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.path,
                                      'Content-Type'  => 'application/json;charset=utf-8',
                                      'Authorization' => "Basic MjE4MWRlNWMtODJmMi00NWQ0LTk2OTctNjg3ZmU0N2I5ZTAw")
        request.body = params.as_json.to_json
        http.request(request)
 
        from = Email.new(email: 'admin@ysl.com')
        to = Email.new(email: 'yslysl8888@gmail.com')
        subject = @order.get_user_name + ' has ended a job!'
        content = Content.new(type: 'text/plain', value: 'Job Type: ' + @order.job_type)
        mail = SendGrid::Mail.new(from, subject, to, content)
        sg = SendGrid::API.new(api_key: "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")
        response = sg.client.mail._('send').post(request_body: mail.to_json)

        
        
        if @order.status == "Credit"
          credit = @order.build_credit(name: @order.creditor_name, amount: @order.amount, status: "Unpaid")
          credit.save
        end
          Account.first.update(sales: Account.first.sales + @order.amount)
          Account.first.update(costs: Account.first.costs + @order.cost)
        
        respond_to do |format|
          format.html {redirect_to new_order_path}# show.html.erb
          format.json { render json: @order }
        end
      end
      
    else
      respond_to do |format|

        format.html {redirect_to new_order_path}# show.html.erb
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
      
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
    
    if @order.destroy
      unless @order.amount == nil
        Account.first.update(sales: Account.first.sales - @order.amount)
      end
      unless @order.cost == nil
        Account.first.update(costs: Account.first.costs - @order.cost)
      end
      respond_to do |format|

        format.html {redirect_to root_path}# show.html.erb
        format.json { render json: @order, status: :created, location: @order }
      end
      
    else
      respond_to do |format|

        format.html {redirect_to root_path}# show.html.erb
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:reference, :status, :job_type, :fixed_type, :creditor_name, :amount, :cost, :member_id, :starttime, :endtime)
    end
 
    def pending_order
      @orders = current_admin.member.orders
      if @orders.exists?
        if @orders.last.status == nil
          redirect_to edit_order_path(@orders.last)
        else
          return
        end
       end
    end
end
