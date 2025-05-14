class InvitationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:accept]  # Skip authentication for accepting invitation
  before_action :set_company

  def new
    @user = User.new
  end

  # Accept the invitation and redirect to set password page
  def accept
    @user = User.find_by_invitation_token(params[:invitation_token])
    
    if @user && @user.invitation_accepted_at.nil?
      # Redirect to set password page if the invitation token is valid
      redirect_to set_password_path(invitation_token: @user.invitation_token)
    else
      redirect_to root_path, alert: "Invalid or expired invitation token."
    end
  end

  def create
    @company = current_user.company
    # Generate a placeholder password for the user
    @user = User.new(user_params.merge(company: @company, password: SecureRandom.hex(8)))

    if @user.save
      # Send the invitation email with the unique token
      UserMailer.invite_user(@user, @company).deliver_now
      redirect_to users_path(company_name: @company.slug), notice: "User was successfully invited."
    else
      render :new
    end
  end

  # Action to show the password update form
  def change_password(invitation)
    @user = User.find_by_invitation_token(invitation)

    if @user.nil? || @user.invitation_accepted_at.nil?
      redirect_to root_path, alert: "Invalid or expired invitation."
    end
  end

  # Action to handle password update
  def update_password
    @user = User.find_by_invitation_token(params[:invitation_token])

    if @user.update(password_params)
      redirect_to dashboard_path(company_name: @company.slug), notice: "Password successfully set. Welcome!"
    else
      render :change_password
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def set_company
    @company = Company.friendly.find(params[:company_name])
  end

  def user_params
    params.require(:user).permit(:email, :role)
  end
end
