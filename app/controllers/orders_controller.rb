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

  # POST /orders
  def create
    @order = Order.new(order_params)
    @order.user_id = 1
    @order.member_id = current_admin.member_id
    member = current_admin.member
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
    end
    if params[:order][:job_type] == "Day"
      @order.amount = member.day_rate
      @order.cost = member.day_cost
    end
    if params[:order][:job_type] == "O.N"
      @order.amount = member.night_rate
      @order.cost = member.night_cost
    end
    @order.starttime = DateTime.now


    if @order.save
      respond_to do |format|

        format.html {redirect_to edit_order_path(@order)}# show.html.erb
        format.json { render json: @order, status: :created, location: @order }
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
      if params[:order][:status] == "Credit"
        Credit.create(amount: @order.amount, name: params[:order][:creditor_name], status: "Unpaid")
      end
    else
      @amount = @order.amount
      @cost = @order.cost
    end
      
    if @order.update(order_params)
      
      if params[:order][:amount].present?
        puts "EXIST"
        sales = Account.first.sales - @amount + @order.amount
        costs = Account.first.costs - @cost + @order.cost
        Account.first.update(sales: sales, costs: costs)
        respond_to do |format|
          format.html {redirect_to admin_edit_path(@order)}# show.html.erb
          format.json { render json: @order }
        end
      else
        puts "NOT EXIST"
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
      params.require(:order).permit(:reference, :status, :job_type, :fixed_type, :creditor_name, :amount, :cost)
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
