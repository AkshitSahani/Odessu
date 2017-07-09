class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_order

   def current_order
     if !session[:order_id].nil?
       Order.find(session[:order_id])
     else
       Order.new
     end
   end

  def cookie_set
    @user = current_user
    return unless current_user
    cookies[:user_id] = @user.id
  end
end
