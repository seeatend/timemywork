class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  # layout false
  # GET /members
  def index
    @page_title = 'All Members'

    @users = Member.all
  end

  # GET /members/1
  def show
    @page_title = 'Show'
    @orders = @member.orders.order(id: :desc)
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
    @page_title = 'Edit'
  end

  # POST /members
  def create
    @member = Member.new(member_params)

    if @member.save
      Admin.create(email: @member.email, password: "11111111", user_type: "members", member_id: @member.id)
      redirect_to members_path, notice: 'Member was successfully created.'
    else
      redirect_to new_user_path, notice: 'Form must be completed.'
    end
  end

  # PATCH/PUT /members/1
  def update
    if @member.update(member_params)
      unless @member.password.nil?
        @member.admin.update(password: @member.password)
      end
      redirect_to @member, notice: 'Member was successfully updated.'
    else
      render :edit
    end
  end
  

  # DELETE /members/1
  def destroy
    @member.destroy
    redirect_to members_url, notice: 'Member was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def member_params
      params.require(:member).permit(:name, :email, :job_rate, :time_rate, :day_rate, :night_rate, :time_cost, :day_cost, :night_cost, :fixed_rate, :hotel_fixed_cost, :normal_fixed_cost, :password)
    end
end
