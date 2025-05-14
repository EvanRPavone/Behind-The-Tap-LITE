class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_action :set_available_partners, only: [:edit, :update, :new, :create]

  # GET /companies
  def index
    @companies = Company.all

    respond_to do |format|
      format.html  # This will render the Haml view
      format.json { render json: @companies }
    end
  end

  # GET /companies/:id
  def show
    @viewed_company = Company.find(params[:id])
    respond_to do |format|
      format.html  # This will render the Haml view
      format.json { render json: @company }
    end
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # POST /companies
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        update_partnerships(@company, company_params[:partner_ids])
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render json: @company, status: :created }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /companies/:id/edit
  def edit
  end

  # PATCH/PUT /companies/:id
  def update
    respond_to do |format|
      if @company.update(company_params)
        update_partnerships(@company, company_params[:partner_ids])
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render json: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/:id
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def switch_company
    company = Company.find(params[:company_id])
  
    # Ensure the user has access to switch to this company
    if current_user.company.partner_companies.include?(company.id) || current_user.admin? || current_user.manager?
      current_user.update!(company_id: company.id)
      flash[:notice] = "You have switched to #{company.name}."
    else
      flash[:alert] = "You are not authorized to switch to this company."
    end
  
    redirect_to company_dashboard_path(company_name: company.slug)
  end

  private

  def set_company
    @company = Company.find(params[:id]) if params[:id]
  end

  def set_available_partners
    @available_partners = Company.where.not(id: @company&.id)
  end

  def company_params
    params.require(:company).permit(:name, partner_ids: [])
  end

  # Handle partnerships
  def update_partnerships(company, partner_ids)
    return unless partner_ids

    partner_ids = partner_ids.reject(&:blank?).map(&:to_i)
    existing_partner_ids = company.partners.pluck(:id)

    # Add new partnerships
    (partner_ids - existing_partner_ids).each do |partner_id|
      company.partnerships.create!(partner_id: partner_id)
    end

    # Remove old partnerships
    (existing_partner_ids - partner_ids).each do |partner_id|
      partnership = company.partnerships.find_by(partner_id: partner_id)
      partnership.destroy if partnership
    end
  end

  def admin_only
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
  end
end
