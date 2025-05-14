class HomeController < ApplicationController
  def welcome
    if user_signed_in?
      if current_user.company.present?
        redirect_to company_dashboard_path(company_name: current_user.company.slug)
      else
        redirect_to root_path, alert: "You must be part of a company to access the dashboard."
      end
    else
      render :welcome
    end
  end
end
