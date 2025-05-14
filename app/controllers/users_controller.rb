class UsersController < ApplicationController
  before_action :set_company
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin_or_manager, except: [:set_password, :update_password]
  before_action :set_companies, only: [:edit]
  skip_before_action :authenticate_user!, only: [:set_password, :update_password]  # Skip authentication for accepting invitation
  before_action :set_user_from_token, only: [:set_password, :update_password]

  # GET /:company_name/users
  def index
    @users = @company.users

    respond_to do |format|
      format.html  # This will render the HAML view
      format.json { render json: @users }  # This will respond with JSON
    end
  end

  # GET /:company_name/users/:id
  def show
    respond_to do |format|
      format.html  # This will render the HAML view
      format.json { render json: @user }  # This will respond with JSON
    end
  end

  # GET /:company_name/users/:id/edit
  def edit
  end

  # PATCH/PUT /:company_name/users/:id
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_path(@company, @user), notice: 'User was successfully updated.' }
        format.json { render json: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /:company_name/users/:id
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path(@company.slug), notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  # GET /users/set_password/:invitation_token
  def set_password
    if @user && @user.invitation_accepted_at.nil?
      # Render the form for setting password
    else
      redirect_to root_path, alert: "Invalid or expired invitation token."
    end
  end

  # PATCH/PUT /users/update_password/:invitation_token
  def update_password
    if @user && @user.update(password_params)
      # Update the invitation accepted time
      @user.update(invitation_accepted_at: Time.now)

      # You can now sign the user in and redirect them
      sign_in(@user)
      redirect_to company_dashboard_path(company_name: @user.company.slug), notice: "Password successfully set. Welcome!"
    else
      render :set_password, alert: "There was an error updating your password."
    end
  end

  private

  def set_user_from_token
    # Find the user by the invitation token
    @user = User.find_by_invitation_token(params[:invitation_token])

    unless @user
      redirect_to root_path, alert: "Invalid invitation token."
    end
  end

  def password_params
    params.require(:user).permit(:first_name, :last_name, :password, :password_confirmation)
  end

  # Set the company using the company slug (company_name)
  def set_company
    @company = Company.friendly.find(params[:company_name]) # Fetch the company by slug
  end

  # Find the user by ID scoped to the company
  def set_user
    @user = @company.users.find_by(id: params[:id]) # Ensure the user belongs to the company
    redirect_to company_users_path(@company.slug), alert: "User not found" if @user.nil?
  end

  def set_companies
    @companies = Company.all
  end

  def authorize_admin_or_manager
    redirect_to root_path unless current_user.admin? || current_user.manager?
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :company_id, :role)
  end
end
