class AdditionLogsController < ApplicationController
  before_action :set_brew
  before_action :set_addition_log, only: [:edit, :update]
  before_action :set_hops, only: [:new, :edit]

  def index
    @addition_logs = @brew.addition_logs
  end

  def new
    @addition_log = @brew.addition_logs.build
  end

  def create
    @addition_log = @brew.addition_logs.build(addition_log_params)
    @addition_log.user = current_user
    if @addition_log.save
      redirect_to brew_path(@company, @brew), notice: 'Addition log created successfully.'
    else
      set_hops
      render :new
    end
  end

  def edit
  end

  def update
    if @addition_log.update(addition_log_params)
      redirect_to brew_path(@company, @brew), notice: 'Addition log updated successfully.'
    else
      set_hops
      render :edit
    end
  end

  private

  def set_brew
    @brew = Brew.find(params[:brew_id])
  end

  def set_addition_log
    @addition_log = @brew.addition_logs.find(params[:id])
  end

  # Fetch only ingredients categorized as hops for selection
  def set_hops
    @hops = Ingredient.where(company: @brew.company, category: 'Hops')
  end

  def addition_log_params
    params.require(:addition_log).permit(:hop_addition_1_id, :hop_addition_1_amount, :hop_addition_2_id, :hop_addition_2_amount, :other_additions, :notes)
  end
end
