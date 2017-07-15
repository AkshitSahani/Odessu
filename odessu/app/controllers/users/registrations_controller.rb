class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :configure_permitted_parameters, if: :devise_controller?
  # GET /resource/sign_up
  # def new
  #   super
  # end

  def profile_1
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

  def profile_3

  end

  def create_profile_3
    byebug #right now this page only has nested attributes, so the code below isnt required. If you include any other
    #user attributes on this page, uncomment the code below.
    # if current_user.update_attributes(sign_up_params)
    #   redirect_to root_path
    # else
    #   render :profile_3
    # end
    params["insecurities"]["insecurity_bottom"].each do |ins|
      current_user.insecurities << Insecurity.create(insecurity_bottom: ins)
    end

    params["insecurities"]["insecurity_top"].each do |ins|
      current_user.insecurities << Insecurity.create(insecurity_top: ins)
    end

    params['issues']['issue_top'].each do |issue_top|
      current_user.issues << Issue.create(issue_top: issue_top)
    end
    params['issues']['issue_bottom'].each do |issue_bottom|
      current_user.issues << Issue.create(issue_bottom: issue_bottom)
    end
    redirect_to root_path
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
    @insecurities = current_user.insecurities
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

  def update_issues
    if request.xhr?
      current_user.issues.delete_all
      params["issues_top"].each do |issue|
        # if Issue.where(issue_top: issue, user_id: current_user.id).empty?
          current_user.issues << Issue.create(issue_top: issue)
        # end
      end
      params["issues_bottom"].each do |issue|
        # if Issue.where(issue_top: issue, user_id: current_user.id).empty?
          current_user.issues << Issue.create(issue_bottom: issue)
        # end
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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :address, :age_range, :height_ft,
      :height_in, :height_cm, :weight,:bust, :hip, :waist, :account_type, :tops_store, :tops_size, :tops_store_fit,
      :bottoms_store, :bottoms_size,:bottoms_store_fit, :bra_size, :bra_cup, :body_shape, :tops_fit, :preference, :bottoms_fit,
      :birthdate, :advertisement_source, :weight_type])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :address, :age_range, :height_ft,
      :height_in, :height_cm, :weight,:bust, :hip, :waist, :account_type, :tops_store, :tops_size, :tops_store_fit,
      :bottoms_store, :bottoms_size,:bottoms_store_fit, :bra_size, :bra_cup, :body_shape, :tops_fit, :preference, :bottoms_fit,
      :birthdate, :advertisement_source, :weight_type])
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
