class TokensController <  ApplicationController
  def create
    token = RegistrationToken.create(:token => params[:token])
    render json: token
  end
end