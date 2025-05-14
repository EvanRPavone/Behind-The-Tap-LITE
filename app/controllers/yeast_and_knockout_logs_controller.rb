# app/controllers/yeast_and_knockout_logs_controller.rb
class YeastAndKnockoutLogsController < ApplicationController
  before_action :set_brew
  before_action :set_yeast_and_knockout_log, only: [:edit, :update]

  def index
    @yeast_and_knockout_logs = @brew.yeast_and_knockout_logs
  end

  def new
    @yeast_and_knockout_log = @brew.yeast_and_knockout_logs.build
    @yeasts = @brew.company.ingredients.where(category: 'Yeast')
  end

  def create
    @yeast_and_knockout_log = @brew.yeast_and_knockout_logs.build(yeast_and_knockout_log_params)
    @yeast_and_knockout_log.user = current_user
    @yeasts = @brew.company.ingredients.where(category: 'Yeast')

    if @yeast_and_knockout_log.save
      redirect_to brew_path(@company, @brew), notice: 'Yeast and Knockout log created successfully.'
    else
      render :new
    end
  end

  def edit
    @yeasts = @brew.company.ingredients.where(category: 'Yeast')
  end

  def update
    if @yeast_and_knockout_log.update(yeast_and_knockout_log_params)
      redirect_to brew_path(@brew), notice: 'Yeast and Knockout log updated successfully.'
    else
      render :edit
    end
  end

  private

  def set_brew
    @brew = Brew.find(params[:brew_id])
  end

  def set_yeast_and_knockout_log
    @yeast_and_knockout_log = @brew.yeast_and_knockout_logs.find(params[:id])
  end

  def yeast_and_knockout_log_params
    params.require(:yeast_and_knockout_log).permit(:whirlpool_start_time, :knockout_start_time, :knockout_end_time,
                                                   :trub_volume, :yeast_source, :yeast_id, :yeast_generation, :notes)
  end
end
