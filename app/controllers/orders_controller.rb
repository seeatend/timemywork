require 'sendgrid-ruby'
include SendGrid

class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]
  before_action :pending_order, only: [:new]
  

  # GET /orders
  def index
    @orders = Order.all.order(endtime: :desc)

    if params[:start]
      start_date = params[:start].to_time
      @orders = @orders.where("endtime >= ?", start_date)
    end

    if params[:end]
      end_date = params[:end].to_time
      @orders = @orders.where("endtime <= ?", end_date)
    end

    respond_to do |format|

      format.html
      format.json { render json: @orders }
    end
  end
  
  #Add Order
  def add_order
    @order = Order.find(params[:id])
    @order.update(add_order: true)
    
    respond_to do |format|
      format.html {redirect_to edit_order_path(@order)}
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
  
  def paid_company
    @order = Order.find(params[:id])
    @member = @order.member
    @order.update(to_company: "Paid")
    redirect_to member_path(@member)
  end
  
  def company_return
    @order = Order.find(params[:id])
    @member = @order.member
    @order.update(to_company: nil)
    redirect_to member_path(@member)
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
      if @order.job_type == "Time Tracking" && @order.add_order
        actual_time = @order.endtime.to_time - (@order.starttime.to_time + 1.hours)
        if actual_time < 0
          actual_time = 0
        else
          actual_time = actual_time
        end
        @order.amount = @order.amount * actual_time / 1.hours.round(0.1) + @order.member.fixed_rate
        @order.cost = @order.cost * actual_time / 1.hours.round(0.1) + @order.member.normal_fixed_cost
      else
        @order.amount = @order.amount * ((@order.endtime.to_time - @order.starttime.to_time) / 1.hours).round(0.1)
        @order.cost = @order.cost * ((@order.endtime.to_time - @order.starttime.to_time) / 1.hours).round(0.1)
      end
    else
      @amount = @order.amount
      @cost = @order.cost
    end
      
    if @order.update(order_params)
      
      if params[:order][:amount].present?
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
          if params[:redirect] == "back"
            puts "HELLOO"
            format.html { redirect_to member_path(@order.member_id) }
            format.json { render json: @order }
          else
            format.html {redirect_to admin_edit_path(@order)}# show.html.erb
            format.json { render json: @order }
          end
        end
      else

        
        
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
        if params[:redirect] == "back"
          format.html { redirect_back(fallback_location: root_path) }# show.html.erb
          format.json { render json: @order, status: :created, location: @order }
        else
          format.html {redirect_to root_path}# show.html.erb
          format.json { render json: @order, status: :created, location: @order }
        end
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
      params.require(:order).permit(:reference, :status, :job_type, :fixed_type, :creditor_name, :amount, :cost, :member_id, :starttime, :endtime, :add_order)
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
