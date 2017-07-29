class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :configure_permitted_parameters, if: :devise_controller?
  # GET /resource/sign_up
  # def new
  #   super
  # end

  def profile_1
    @stores = (["Select a store"] << Store.all.distinct.order(:store_name).pluck(:store_name)).flatten
    if request.xhr?
      @sizes = Store.where(store_name: params['store_name'], feature: "BUST").map{|x| x.store_size}
      respond_to do |format|
        format.html
        format.json { render json: @sizes }
      end
    end
    # build_resource({})
    # yield resource if block_given?
    # respond_with resource
  end

  def create_profile_1
    if current_user.update_attributes(sign_up_params)
      redirect_to profile_2_path(current_user)
    else
      render :profile_1
    end
  end

  def profile_2

  end

  def create_profile_2
    if current_user.update_attributes(sign_up_params)
      redirect_to profile_3_path(current_user)
    else
      render :profile_2
    end
  end

  def create_body_shape
    if request.xhr?
      current_user.update_attributes(body_shape: params['body_shape'])
      # redirect_to profile_3_path(current_user)
      location = "/profile_3.#{current_user.id}"
      render :js => "window.location = '#{location}'"
    end
  end

  def profile_3

  end


  def create_profile_3
    #right now this page only has nested attributes, so the code below isnt required. If you include any other
    #user attributes on this page, uncomment the code below.
    # if current_user.update_attributes(sign_up_params)
    #   redirect_to root_path
    # else
    #   render :profile_3
    # end
    # params["insecurities"]["insecurity_bottom"].each do |ins|
    #   current_user.insecurities << Insecurity.create(insecurity_bottom: ins)
    # end
    #
    # params["insecurities"]["insecurity_top"].each do |ins|
    #   current_user.insecurities << Insecurity.create(insecurity_top: ins)
    # end

    params['issues']['issue_fit'].each do |issue_fit|
      current_user.issues << Issue.create(issue_fit: issue_fit)
    end
    params['issues']['issue_length'].each do |issue_length|
      current_user.issues << Issue.create(issue_length: issue_length)
    end
    redirect_to profile_4_path
  end

  def profile_4
    #code
  end

  def create_profile_4
    #for when the subscription model is live
    # customer = Stripe::Customer.create(
    #   :email => current_user.email,
    #   :source  => params[:stripeToken]
    # )
    #
    # Stripe::Subscription.create(
    #   :customer => customer.id,
    #   :plan => "What We Offer",
    # )
    #
    # current_user.update_attributes(stripe_customer_id: customer.id)

    # if ((current_user.height_ft != nil || current_user.height_cm != nil) && current_user.weight != nil)
    #   predictions = User.calcFromHeightWeight(current_user)
    # elsif (((current_user.height_ft != nil || current_user.height_cm != nil) && current_user.weight == nil) && current_user.tops_store != "Select a store" && current_user.tops_size != nil && current_user.bottoms_store != "Select a store" && current_user.bottoms_size != nil)
    #   predictions = User.calcFromStoresAndSizes(current_user)
    # elsif (((current_user.height_ft == nil && current_user.height_cm == nil) && current_user.weight != nil) && current_user.tops_store != "Select a store" && current_user.tops_size != nil && current_user.bottoms_store != "Select a store" && current_user.bottoms_size != nil)
    #   predictions = User.calcFromStoresAndSizes(current_user)
    # elsif (((current_user.height_ft == nil && current_user.height_cm == nil) && current_user.weight == nil) && current_user.tops_store != "Select a store" && current_user.tops_size != nil && current_user.bottoms_store != "Select a store" && current_user.bottoms_size != nil)
    #   predictions = User.calcFromStoresAndSizes(current_user)
    # end
    #
    # current_user.update_attributes(predicted_bust: predictions['true_bust'], predicted_waist: predictions['true_waist'], predicted_hip: predictions['true_hip'])

    if current_user.update_attributes(sign_up_params)
      session[:user_signed_up?] = true
      redirect_to products_path
    else
      render :profile_4
    end
  end

  def update_terms_of_service
    if request.xhr?
      if params['terms']['email_subscription'] == 'true'
        current_user.update_attributes(email_subscription: true)
      end

      if params['terms']['terms_agreed?'] == 'true'
        current_user.update_attributes(terms_agreed?: true)
      end
    end
  end

  def show
    @user = current_user
    @bmi_results = User.bmiCalculator(@user)
    @shape_guess_data = User.guessBodyShapeNew(current_user, @bmi_results[:bmi])
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    resource.save
    session[:user_id] = resource.id
    @resource = resource
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  def edit_profile
    @issues_top = current_user.issues.where(issue_bottom: nil)
    @issues_bottom = current_user.issues.where(issue_top: nil)
    @insecurities_top = current_user.insecurities.where(insecurity_bottom: nil)
    @insecurities_bottom= current_user.insecurities.where(insecurity_top: nil)
  end

  def update_profile
    # current_user.issues.delete_all
    # params["issue"]["issue_top"].each do |issue|
    #   # if Issue.where(issue_top: issue, user_id: current_user.id).empty?
    #     current_user.issues << Issue.create(issue_top: issue)
    #   # end
    # end
    # params["issue"]["issue_bottom"].each do |issue|
    #   # if Issue.where(issue_bottom: issue, user_id: current_user.id).empty?
    #     current_user.issues << Issue.create(issue_bottom: issue)
    #   # end
    # end
    if current_user.update_attributes(sign_up_params)
      redirect_to user_path(current_user), notice: "Profile Updated Successfully!"
    else
      render :edit_profile
    end
  end

  def update_issues #and insecurities
    if request.xhr?
      current_user.issues.delete_all
      current_user.insecurities.delete_all

      params["issues_top"].each do |issue|
          current_user.issues << Issue.create(issue_top: issue)
      end
      params["issues_bottom"].each do |issue|
          current_user.issues << Issue.create(issue_bottom: issue)
      end

      params["insecurities_top"].each do |insecurity|
          current_user.insecurities << Insecurity.create(insecurity_top: insecurity)
      end
      params["insecurities_bottom"].each do |insecurity|
          current_user.insecurities << Insecurity.create(insecurity_bottom: insecurity)
      end
    end
  end
  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :address, :age_range, :height_ft,
      :height_in, :height_cm, :weight,:bust, :hip, :waist, :account_type, :tops_store, :tops_size, :tops_store_fit,
      :bottoms_store, :bottoms_size,:bottoms_store_fit, :bra_size, :bra_cup, :body_shape, :tops_fit, :preference, :bottoms_fit,
      :birthdate, :advertisement_source, :weight_type, :stripe_customer_id, :predicted_hip, :predicted_bust, :predicted_waist,
       :bust_waist_hip_inseam_type, :inseam, :predicted_inseam, :phone_number, :email_subscription, :terms_agreed?])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:full_name, :address, :age_range, :height_ft,
      :height_in, :height_cm, :weight,:bust, :hip, :waist, :account_type, :tops_store, :tops_size, :tops_store_fit,
      :bottoms_store, :bottoms_size,:bottoms_store_fit, :bra_size, :bra_cup, :body_shape, :tops_fit, :preference, :bottoms_fit,
      :birthdate, :advertisement_source, :weight_type, :stripe_customer_id, :predicted_hip, :predicted_bust, :predicted_waist,
       :bust_waist_hip_inseam_type, :inseam, :predicted_inseam, :phone_number, :email_subscription, :terms_agreed?])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
    profile_1_path(current_user)
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
