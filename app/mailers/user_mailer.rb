class UserMailer < ApplicationMailer
  def invite_user(user, company)
    @user = user
    @company = company
    @invite_url = set_password_url(company_name: @company.slug, invitation_token: @user.invitation_token)

    mail(to: @user.email, subject: "You are invited to join #{@company.name}")
  end
end
