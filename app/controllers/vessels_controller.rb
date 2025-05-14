class VesselsController < ApplicationController
  before_action :set_company
  before_action :set_vessel, only: [:show, :edit, :update, :destroy]

  # GET /:company_name/vessels
  def index
    @vessels = @company.vessels

    respond_to do |format|
      format.html  # Render Haml view
      format.json { render json: @vessels }  # Return JSON response
    end
  end

  # GET /:company_name/vessels/:id
  def show
    respond_to do |format|
      format.html  # Render Haml view
      format.json { render json: @vessel }  # Return JSON response
    end
  end

  # GET /:company_name/vessels/new
  def new
    @vessel = @company.vessels.build
  end

  # POST /:company_name/vessels
  def create
    @vessel = @company.vessels.build(vessel_params)

    respond_to do |format|
      if @vessel.save
        format.html { redirect_to vessels_path(company_name: @company.slug), notice: 'Vessel was successfully created.' }
        format.json { render json: @vessel, status: :created }
      else
        format.html { render :new }
        format.json { render json: @vessel.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /:company_name/vessels/:id/edit
  def edit; end

  # PATCH/PUT /:company_name/vessels/:id
  def update
    respond_to do |format|
      if @vessel.update(vessel_params)
        format.html { redirect_to vessels_path(company_name: @company.slug), notice: 'Vessel was successfully updated.' }
        format.json { render json: @vessel }
      else
        format.html { render :edit }
        format.json { render json: @vessel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /:company_name/vessels/:id
  def destroy
    @vessel.destroy

    respond_to do |format|
      format.html { redirect_to company_vessels_path(company_name: @company.slug), notice: 'Vessel was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def set_company
    @company = Company.find_by!(slug: params[:company_name])
  end

  def set_vessel
    @vessel = @company.vessels.find(params[:id])
  end

  def vessel_params
    params.require(:vessel).permit(:name, :size_bbl)
  end
end
