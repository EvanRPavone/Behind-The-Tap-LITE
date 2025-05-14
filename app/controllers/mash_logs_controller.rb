class MashLogsController < ApplicationController
  before_action :set_brew

  def index
    @mash_logs = @brew.mash_logs
  end

  def new
    @mash_log = @brew.mash_logs.build
  end

  def create
    @mash_log = @brew.mash_logs.build(mash_log_params)
    @mash_log.user = current_user
    if @mash_log.save
      redirect_to brew_path(@company, @brew), notice: 'Mash log created successfully.'
    else
      render :new
    end
  end

  private

  def set_brew
    @brew = Brew.find(params[:brew_id])
  end

  def mash_log_params
    params.require(:mash_log).permit(:mash_in_time, :mash_complete_time, :mash_temp, :mash_ph, :notes)
  end
end
