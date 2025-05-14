class FermentationLog < ApplicationRecord
  belongs_to :brew
  belongs_to :user

  # validates :stage, :day, :plato, :ph, :tank_temp, presence: true

  # after_save :update_brew_status

  validates :og_was, :og_is, numericality: true, allow_nil: true

  enum status: { primary: 'primary', d_rest: 'd_rest', lager: 'lager', crash: 'crash', fined: 'fined', carbed: 'carbed', completed: 'completed' }

  validates :og_was, :og_is, :carbed_vol, numericality: true, allow_nil: true
  validates :status, inclusion: { in: %w[primary d_rest lager crash fined carbed completed] }
  validates :day, presence: true, numericality: { only_integer: true }
  validates :log_date, presence: true
  private

  # def update_brew_status
  #   brew.update_status_based_on_fermentation
  # end
end
