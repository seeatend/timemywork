class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
   layout :layout
   

    private

   def layout
     devise_controller? ? false : "application"
   end
end
