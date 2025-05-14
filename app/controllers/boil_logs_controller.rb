class BoilLogsController < ApplicationController
  before_action :set_brew
  before_action :set_boil_log, only: [:edit, :update]

  def index
    @boil_logs = @brew.boil_logs.order(created_at: :desc)
  end

  ### **🔥 PREBOIL LOGS ***

  def new_preboil
    existing_preboil_log = @brew.boil_logs.find_by(stage: 'preboil')

    if existing_preboil_log
      Rails.logger.warn("Preboil log already exists for Brew ##{@brew.id}. Redirecting to edit.")
      redirect_to edit_brew_boil_log_path(company_name: @brew.company.slug, brew_id: @brew, id: existing_preboil_log.id),
                  alert: 'A Preboil log already exists. You can edit the existing log instead.'
    else
      @boil_log = @brew.boil_logs.build(stage: 'preboil')
    end
  end

  def create_preboil
    existing_preboil_log = @brew.boil_logs.find_by(stage: 'preboil')

    if existing_preboil_log
      Rails.logger.warn("Preboil log already exists for Brew ##{@brew.id}. Redirecting to edit.")
      redirect_to edit_brew_boil_log_path(company_name: @brew.company.slug, brew_id: @brew, id: existing_preboil_log.id),
                  alert: 'A Preboil log already exists. You can edit the existing log instead.'
    else
      @boil_log = @brew.boil_logs.build(preboil_params.merge(stage: 'preboil'))
      @boil_log.user = current_user
      save_boil_log('Preboil')
    end
  end

  ### **🔥 POSTBOIL LOGS ***

  def new_postboil
    @preboil_log = @brew.boil_logs.find_by(stage: 'preboil')

    if @preboil_log.nil?
      Rails.logger.warn("No Preboil log found for Brew ##{@brew.id} while accessing Postboil form")
      redirect_to new_preboil_brew_boil_logs_path(company_name: @brew.company.slug, brew_id: @brew),
                  alert: 'You must create a Preboil log before adding a Postboil log.'
    else
      @boil_log = @preboil_log
    end
  end

  def create_postboil
    preboil_log = @brew.boil_logs.find_by(stage: 'preboil')

    if preboil_log
      if preboil_log.update(postboil_params.merge(stage: 'completed'))
        preboil_log.brew.run_calculations
        Rails.logger.info("Postboil data merged into Preboil log for Brew ##{@brew.id}")
        redirect_to brew_path(@brew.company.slug, @brew), notice: 'Postboil log added successfully.'
      else
        Rails.logger.warn("Failed to merge Postboil data into Preboil log for Brew ##{@brew.id}")
        render :new_postboil
      end
    else
      Rails.logger.warn("No Preboil log found for Brew ##{@brew.id} while creating Postboil log")
      redirect_to new_preboil_brew_boil_logs_path(company_name: @brew.company.slug, brew_id: @brew),
                  alert: 'You must create a Preboil log before adding a Postboil log.'
    end
  end

  ### **🔥 EDIT & UPDATE LOGIC ***

  def edit
    if @boil_log.stage == "preboil"
      # If only preboil log exists, only allow editing preboil data
      @edit_mode = "preboil"
    elsif @boil_log.stage == "completed"
      # If postboil has been completed, allow editing full log
      @edit_mode = "full"
    end
  end

  def update
    if @boil_log.stage == "preboil"
      if @boil_log.update(preboil_params)
        Rails.logger.info("Preboil log updated successfully for Brew ##{@brew.id}")
        redirect_to brew_path(company_name: params[:company_name], brew_id: @brew.id), notice: 'Preboil log updated successfully.'
      else
        Rails.logger.warn("Failed to update Preboil log for Brew ##{@brew.id}")
        render :edit
      end
    elsif @boil_log.stage == "completed"
      if @boil_log.update(boil_log_params)
        Rails.logger.info("Completed Boil log updated successfully for Brew ##{@brew.id}")
        redirect_to brew_path(company_name: params[:company_name], brew_id: @brew.id), notice: 'Boil log updated successfully.'
      else
        Rails.logger.warn("Failed to update Completed Boil log for Brew ##{@brew.id}")
        render :edit
      end
    else
      Rails.logger.warn("Unexpected boil log stage: #{@boil_log.stage} for Brew ##{@brew.id}")
      redirect_to brew_path(company_name: params[:company_name], brew_id: @brew.id), alert: "Invalid boil log stage."
    end
  end

  private

  def set_brew
    @brew = Brew.find(params[:brew_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to brews_path, alert: 'Brew not found.'
  end

  def set_boil_log
    @boil_log = @brew.boil_logs.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to brew_path(@brew.company.slug, @brew), alert: 'Boil log not found.'
  end

  def save_boil_log(log_type)
    if @boil_log.save
      @boil_log.brew.run_calculations
      Rails.logger.info("#{log_type} log created for Brew ##{@brew.id} by User ##{current_user.id}")
      redirect_to brew_path(@brew.company.slug, @brew), notice: "#{log_type} log created successfully."
    else
      Rails.logger.warn("#{log_type} log creation failed for Brew ##{@brew.id}")
      render "new_#{log_type.downcase}"
    end
  end

  # Strong params for Preboil Log
  def preboil_params
    params.require(:boil_log).permit(
      :vorlauf_start_time, :vorlauf_complete_time, :sparge_start_time, :sparge_amount,
      :sparge_complete_time, :kettle_full_time, :preboil_volume, :preboil_gravity,
      :preboil_ph, :original_grav, :notes
    )
  end

  # Strong params for Postboil Log
  def postboil_params
    params.require(:boil_log).permit(
      :boil_achieved_time, :boil_complete_time, :post_boil_amount, :post_boil_gravity,
      :post_boil_ph, :notes
    )
  end

  # Strong params for full Boil Log editing
  def boil_log_params
    params.require(:boil_log).permit(
      :stage, :vorlauf_start_time, :vorlauf_complete_time, :original_grav,
      :sparge_start_time, :sparge_amount, :sparge_complete_time, :kettle_full_time,
      :preboil_volume, :preboil_gravity, :preboil_ph, :boil_achieved_time,
      :boil_complete_time, :post_boil_amount, :post_boil_gravity, :post_boil_ph, :notes
    )
  end
end
