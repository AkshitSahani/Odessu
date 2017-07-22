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

  # def cookie_set
  #   @user = current_user
  #   return unless current_user
  #   cookies[:user_id] = @user.id
  # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :address, :age_range, :height_ft,
      :height_in, :height_cm, :weight,:bust, :hip, :waist, :account_type, :tops_store, :tops_size, :tops_store_fit,
      :bottoms_store, :bottoms_size,:bottoms_store_fit, :bra_size, :bra_cup, :body_shape, :tops_fit, :preference, :bottoms_fit,
      :birthdate, :advertisement_source, :weight_type, :predicted_hip, :predicted_bust, :predicted_waist, :bust_waist_hip_inseam_type,
      :inseam, :phone_number, :stripe_customer_id, :terms_agreed?, :email_subscription])
  end
end
