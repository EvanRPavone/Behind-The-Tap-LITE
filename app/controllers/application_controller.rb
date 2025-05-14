class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_current_company, unless: :devise_controller?

  private

  # Set the current company based on either slug or ID, or the user's associated company
  def set_current_company
    if current_user.present?
      if params[:company_name].present?
        @company = Company.find_by(slug: params[:company_name])
      elsif params[:company_id].present?
        @company = Company.find_by(id: params[:company_id])
      else
        @company = current_user.company  # Use user's associated company
      end

      unless @company
        # Log the error for debugging purposes
        logger.error "Company not found: #{params[:company_name] || params[:company_id]}"
        
        # Redirect or show a user-friendly error page
        redirect_to root_path, alert: "Company not found. Please select a valid company."
      end
    end
  end

  # Custom redirection after the user signs in
  def after_sign_in_path_for(resource)
    if resource.company.present?
      # Redirect to the company's dashboard after sign-in
      company_dashboard_path(company_name: resource.company.slug)
    else
      # Default to root if no company is associated
      authenticated_root_path
    end
  end
end