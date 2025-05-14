class FermentationLogsController < ApplicationController
  before_action :set_brew

  def index
    @fermentation_logs = @brew.fermentation_logs
  end

  def new
    last_ferm_log = @brew.fermentation_logs.order(created_at: :desc).first
    last_boil_log = @brew.boil_logs.order(created_at: :desc).last
  
    @fermentation_log = @brew.fermentation_logs.build
  
    if last_ferm_log
      # Pre-fill with the last fermentation log's data
      @fermentation_log.attributes = {
        og_was: last_ferm_log.og_is,
        carbed_vol: last_ferm_log.carbed_vol,
        status: last_ferm_log.status,
        day: last_ferm_log.day.to_i + 1, # Increment day by 1
        plato: last_ferm_log.plato,
        ph: last_ferm_log.ph,
        tank_temp: last_ferm_log.tank_temp,
        action: last_ferm_log.action
      }
      @tooltip_text = "This value is from the previous fermentation log."
    elsif last_boil_log
      # Pre-fill `og_was` with the post_boil_gravity from the last boil log
      @fermentation_log.og_was = last_boil_log.post_boil_gravity
      @tooltip_text = "This value is from the most recent boil log (post-boil gravity)."
    else
      # Default tooltip for when no logs exist
      @tooltip_text = "No previous logs available. Please input data manually."
    end
  end


  def create
    @fermentation_log = @brew.fermentation_logs.build(fermentation_log_params)
    @fermentation_log.user = current_user  # Track the user who created the log
  
    if status_conditions_met?(@fermentation_log)
      if @fermentation_log.save
        @brew.run_calculations
        @brew.update_status_based_on_fermentation  # Update brew status based on the new log entry
        redirect_to brew_path(@brew.company, @brew), notice: 'Fermentation log created successfully.'
      else
        flash[:error] = @fermentation_log.errors.full_messages.to_sentence
        render :new
      end
    else
      render :new
    end
  end

  private

  def status_conditions_met?(log)
    case log.status
    when 'fined'
      unless log.tank_temp.present? && log.tank_temp < 50
        flash[:error] = "Fined status conditions not met. Tank temperature must be below 50°F."
        return false
      end
    when 'completed'
      unless log.tank_temp.present? && log.tank_temp < 41 && @brew.fermentation_logs.where(status: 'lager').exists?
        flash[:error] = "Completed status conditions not met. Tank temperature must be below 41°F, and a lager fermentation log must exist."
        return false
      end
    when 'carbed'
      unless log.carbed_vol.present? && log.carbed_vol >= @brew.target_carbed_vol
        flash[:error] = "Carbed status conditions not met. Carbonation volume must meet or exceed the target of #{@brew.target_carbed_vol}."
        return false
      end
    end
    true
  end

  def set_brew
    @brew = Brew.find(params[:brew_id])
  end

  def fermentation_log_params
    params.require(:fermentation_log).permit(
      :og_was,
      :og_is,
      :carbed_vol,
      :status,
      :day,
      :plato,
      :ph,
      :tank_temp,
      :action,
      :notes,
      :log_date
    )
  end
end
