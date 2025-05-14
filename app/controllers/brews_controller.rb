class BrewsController < ApplicationController
  before_action :set_brew, only: [:show, :edit, :update, :destroy, :transfer_kegs, :empty_vessel]
  before_action :set_company

  # GET /brews
  def index
    @brews = @company.brews

    respond_to do |format|
      format.html  # Render Haml view
      format.json { render json: @brews }  # Return JSON response
    end
  end

  # GET /brews/:id
  def show
    @keg_sizes = {
      'Full Barrel' => 15.5,
      'Half Barrel' => 7.75,
      'Sixtel' => 5.16
    }
    respond_to do |format|
      format.html  # Render Haml view
      format.json { render json: @brew }  # Return JSON response
    end
  end

  # GET /brews/new
  def new
    @brew = @company.brews.build(brew_date: Date.today)
    @recipes = @company.recipes.order(:name, :size_bbl) # Fetch all recipes for the dropdown
    # @vessels = @company.vessels.where.not(id: Brew.select(:vessel_id).where.not(vessel_id: nil))  # Exclude vessels that are currently in use
    @vessels = @company.vessels.where(in_use: false)  # Exclude vessels in use
  end

  # POST /brews
  def create
    @brew = @company.brews.build(brew_params)
    @brew.status = :primary  # Automatically set the status to primary
    respond_to do |format|
      if @brew.save
        begin
          # Enqueue inventory reduction job asynchronously or synchronously
          # ReduceInventoryJob.perform_now(@brew.id) # For immediate feedback during demo
          @brew.vessel.update(in_use: true)
          format.html { redirect_to brew_path(@company, @brew), notice: 'Brew was successfully created.' }
          format.json { render json: @brew, status: :created }
        rescue ActiveRecord::Rollback => e
          # Handle rollback due to insufficient stock
          @brew.destroy # Cleanup
          Rails.logger.error("Inventory rollback: #{e.message}")
          format.html { redirect_to new_brew_path(company_name: @company.slug), alert: "Brew creation failed: #{e.message}" }
          format.json { render json: { error: e.message }, status: :unprocessable_entity }
        rescue StandardError => e
          # Catch-all for other errors
          @brew.destroy # Cleanup
          Rails.logger.error("Unexpected error during brew creation: #{e.message}")
          format.html { redirect_to new_brew_path(company_name: @company.slug), alert: "An unexpected error occurred during brew creation. #{e.message}" }
          format.json { render json: { error: 'Unexpected error occurred.' }, status: :unprocessable_entity }
        end
      else
        @recipes = @company.recipes.order(:name, :size_bbl) # Fetch recipes again
        @vessels = @company.vessels # Fetch vessels again
        format.html { render :new }
        format.json { render json: @brew.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /brews/:id/edit
  def edit
    @brew = @company.brews.find(params[:id])
    @recipes = @company.recipes  # Fetch available recipes for selection
    # @vessels = @company.vessels.where.not(id: Brew.select(:vessel_id).where.not(vessel_id: nil))  # Exclude vessels in use
    @vessels = @company.vessels.where(in_use: false)  # Exclude vessels in use
  end

  # PATCH/PUT /brews/:id
  def update
    respond_to do |format|
      if @brew.update(brew_params)
        @brew.vessel.update(in_use: true)
        format.html { redirect_to brew_path(@brew, company_name: @company.slug), notice: 'Brew was successfully updated.' }
        format.json { render :show, status: :ok, location: @brew }
      else
        format.html { render :edit }
        format.json { render json: @brew.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brews/:id
  def destroy
    @brew.destroy
    respond_to do |format|
      format.html { redirect_to brews_url, notice: 'Brew was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def transfer_kegs
    @brew = Brew.find(params[:id])
  
    # Parse keg quantities from the form
    full_barrels = params[:full_barrels].to_i
    half_barrels = params[:half_barrels].to_i
    sixtels = params[:sixtels].to_i
  
    # Calculate total volume of requested kegs
    total_requested_volume = (full_barrels * 15.5) + (half_barrels * 7.75) + (sixtels * 5.16)
    remaining_volume = @brew.recipe.size_bbl * 31 - @brew.kegs.sum(&:size)
  
    # Validate against remaining volume
    if total_requested_volume > remaining_volume
      flash[:alert] = "Not enough volume available. Only #{remaining_volume.round(2)} gallons left."
      redirect_to brew_path(company_name: @brew.company.slug, id: @brew) and return
    end
  
    # Create kegs and update remaining volume
    Keg.transaction do
      full_barrels.times { Keg.create!(brew: @brew, size: 15.5, company: @brew.company, recipe: @brew.recipe) }
      half_barrels.times { Keg.create!(brew: @brew, size: 7.75, company: @brew.company,recipe: @brew.recipe) }
      sixtels.times { Keg.create!(brew: @brew, size: 5.16, company: @brew.company, recipe: @brew.recipe) }
    end
  
    flash[:notice] = "Kegs successfully transferred. Remaining volume: #{(remaining_volume - total_requested_volume).round(2)} gallons."
    redirect_to brew_path(company_name: @brew.company.slug, id: @brew)
  end
  
  # POST /:company_name/brews/:id/empty_vessel
  def empty_vessel
    if @brew.completed? && !@brew.fulfilled?
      @brew.update!(status: :fulfilled)

      flash[:notice] = "Vessel emptied successfully. Brew ##{@brew.batch_no} is now fulfilled."
      @brew.vessel.update!(in_use: false)
      redirect_to company_dashboard_path(company_name: @brew.company.slug)
    else
      flash[:alert] = "Cannot empty vessel. Ensure the brew is completed but not already fulfilled."
      redirect_to brew_path(company_name: @brew.company.slug, id: @brew.id)
    end
  end



  private

  def set_brew
    @brew = @company.brews.find(params[:id])
  end

  def set_company
    # Rails.logger.debug "Params: #{params.inspect}"  # Log the params
    if params[:company_name]
      @company = Company.friendly.find(params[:company_name])
    elsif params[:company_id]
      @company = Company.find(params[:company_id])
    else
      raise ActiveRecord::RecordNotFound, "Company not found"
    end
    # Rails.logger.debug "Found company: #{@company.inspect}"
  end

  # Permit the required parameters
  def brew_params
    params.require(:brew).permit(:batch_no, :in_tank, :status, :brew_date, :carbed_vol, :next_steps_id, :yeast_gen, :original_grav, :int_sg, :og_was, :og_is, :target_p, :ph, :current_sg, :vessel_id, :est_abv, :target_abv, :d_rest_start, :crash_start, :target_release, :notes, :target_carbed_vol)
  end
end
