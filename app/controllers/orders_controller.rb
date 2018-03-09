class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]
  before_action :pending_order, only: [:new]

  # GET /orders
  def index
    @orders = Order.all

    render json: @orders
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

  # POST /orders
  def create
    @order = Order.new(order_params)
    member_id = 1
    @order.member_id = member_id
    @order.user_id = 1
    member = current_admin.member
    if params[:order][:job_type] == "Fixed"
      @order.amount = member.fixed_rate
      if params[:order][:fixed_type] == "Hotel"
        @order.cost = @order.amount * 0.2
      else
        @order.cost = @order.amount * 0.3
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
    if @order.status == "Time Tracking"
      @order.amount = @order.amount * ((@order.starttime.to_time - @order.endtime.to_time ) / 1.hours).ceil
    end
    if @order.update(order_params)
      respond_to do |format|

        format.html {redirect_to new_order_path}# show.html.erb
        format.json { render json: @order }
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
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:reference, :status, :job_type, :fixed_type)
    end
 
    def pending_order
      @orders = Order.all
      if @orders.exists?
        if @orders.last.status == nil
          redirect_to edit_order_path(@orders.last)
        else
          return
        end
       end
    end
end
