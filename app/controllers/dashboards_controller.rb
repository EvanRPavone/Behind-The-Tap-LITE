class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company

  def show
    @q = @company.brews.ransack(params[:q])
    @brews = @q.result(distinct: true) # Fetch the results based on the query

    # Separate active and completed brews for display
    @active_brews = @brews.where.not(status: ['completed', 'fulfilled', 'archived'])
    @completed_brews = @brews.where(status: ['completed', 'fulfilled', 'archived'])

    if (current_user.brewer? || current_user.manager?) && current_user.company.partnerships.any?
      @companies = []
      current_user.company.partnerships.each do |p|
        @companies << p.company
      end
    elsif current_user.admin?
      @companies = Company.all
    end
  end

  private

  def set_company
    @company = current_user.company
  end
end
