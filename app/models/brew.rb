class Brew < ApplicationRecord
  has_many :mash_logs, dependent: :destroy
  has_many :boil_logs, dependent: :destroy
  has_many :addition_logs, dependent: :destroy
  has_many :yeast_and_knockout_logs, dependent: :destroy
  has_many :fermentation_logs, dependent: :destroy
  has_many :kegs, dependent: :destroy

  belongs_to :company
  belongs_to :vessel
  belongs_to :next_steps, class_name: 'Step', optional: true
  belongs_to :recipe, foreign_key: 'in_tank', primary_key: 'id', class_name: 'Recipe'

  after_save :update_status_based_on_fermentation, if: :fermentation_log_saved?

  serialize :notes, Array, coder: JSON

  enum status: { primary: 0, d_rest: 1, lager: 2, crash: 3, fined: 4, carbed: 5, completed: 6, fulfilled: 7, archived: 8 }

  validates :batch_no, :in_tank, :brew_date, presence: true

  scope :active, -> { where.not(status: [:completed, :fulfilled]) }
  scope :completed, -> { where(status: [:completed, :fulfilled]) }

  before_save :set_stage_dates
  after_update :free_vessel_if_fulfilled

  # after_create_commit :enqueue_inventory_reduction_job

  ### **🔥 Log Management & Notes Retrieval**

  def latest_log_note
    logs_with_notes = (mash_logs + boil_logs + addition_logs + yeast_and_knockout_logs + fermentation_logs)
                      .select { |log| log.notes.present? }
    latest_note_log = logs_with_notes.max_by(&:updated_at)
    latest_note_log&.notes
  end

  ### **📊 Metrics & Volume Calculations**

  def original_grav
    last_boil_log = boil_logs.last
    preboil_log = boil_logs.last
    last_fermentation_log = fermentation_logs.last

    last_fermentation_log&.og_is ||
    last_boil_log&.post_boil_gravity ||
      preboil_log&.original_grav ||
      'N/A'
  end

  def remaining_volume
    recipe.size_bbl * 31
  end

  def transfer_to_kegs(keg_sizes)
    remaining = remaining_volume
    created_kegs = []

    keg_sizes.each do |size|
      break if remaining <= 0

      keg_size = size.to_f
      if keg_size <= remaining
        created_kegs << kegs.create!(size: keg_size, size_unit: 'gallon', status: 'filled', company: company)
        remaining -= keg_size
      end
    end

    created_kegs
  end

  ### **📊 SG & ABV Calculations**
  
  def run_calculations
    self.calculate_values
  end

  def calculate_values
    self.int_sg = calculate_int_sg
    self.current_sg = calculate_current_sg
    self.est_abv = calculate_est_abv
    update_columns(int_sg: int_sg, current_sg: current_sg, est_abv: est_abv)
  end

  def calculate_int_sg
    return nil unless boil_logs.last&.post_boil_gravity.present?
    1 + (boil_logs.last.post_boil_gravity / (258.6 - ((boil_logs.last.post_boil_gravity / 258.2) * 227.1)))
  end

  def calculate_current_sg
    return nil unless fermentation_logs.last&.og_is.present?
    1 + (fermentation_logs.last.og_is / (258.6 - ((fermentation_logs.last.og_is / 258.2) * 227.1)))
  end

  def calculate_est_abv
    return nil unless int_sg.present? && current_sg.present?
    (76.08 * (int_sg - current_sg) / (1.775 - int_sg)) * (current_sg / 0.74)
  end

  ### **🔥 Status Updates Based on Fermentation Logs**

  def update_status_based_on_fermentation
    last_log = fermentation_logs.order(created_at: :desc).first
    return unless last_log
  
    BREW_LOGGER.debug "Checking status update for Brew ##{id} based on last fermentation log."
  
    case last_log.status
    when "primary", "d_rest", "lager", "crash"
      simple_status_update(last_log.status)
    when "fined"
      handle_fined_status(last_log)
    when "carbed"
      handle_carbed_status(last_log)
    when "completed"
      handle_completed_status(last_log)
    else
      BREW_LOGGER.warn "Unknown status '#{last_log.status}' for Brew ##{id}."
    end
  end

  def simple_status_update(new_status)
    if Brew.statuses[new_status.to_sym] > Brew.statuses[status.to_sym]
      update!(status: new_status)
      BREW_LOGGER.info "Brew ##{id} updated to #{new_status.capitalize} status."
    end
  end

  def handle_fined_status(last_log)
    if last_log.tank_temp.present? && last_log.tank_temp < 50
      update!(status: :fined)
      BREW_LOGGER.info "Brew ##{id} updated to Fined status."
    else
      self.errors.add(:base, "Fined status conditions not met. Ensure the tank temperature is below 50°F.")
      BREW_LOGGER.debug "Fined status conditions not met for Brew ##{id}."
    end
  end

  def handle_carbed_status(last_log)
    if last_log.carbed_vol.present? && last_log.carbed_vol >= target_carbed_vol
      update!(status: :carbed)
      BREW_LOGGER.info "Brew ##{id} updated to Carbed status."
    else
      self.errors.add(:base, "Carbed status conditions not met. Ensure the carbonation volume is at or above the target level (#{target_carbed_vol} volumes).")
      BREW_LOGGER.debug "Carbed status conditions not met for Brew ##{id}."
    end
  end

  def handle_completed_status(last_log)
    if fermentation_logs.where(status: 'lager').any? && last_log.tank_temp.present? && last_log.tank_temp < 41
      update!(status: :completed)
      BREW_LOGGER.info "Brew ##{id} updated to Completed status."
    else
      self.errors.add(:base, "Completed status conditions not met. Ensure the tank temperature is below 41°F and a lager fermentation log exists.")
      BREW_LOGGER.debug "Completed status conditions not met for Brew ##{id}."
    end
  end

  ### **🛠 Utility & Callbacks**

  def free_vessel_if_fulfilled
    vessel.update(in_use: false) if saved_change_to_status? && fulfilled? && vessel
  end

  def fermentation_log_saved?
    saved_changes? && saved_changes.keys.include?('fermentation_logs')
  end

  def set_stage_dates
    self.d_rest_start = Date.today if status_changed? && d_rest? && d_rest_start.nil?
    self.crash_start = Date.today if status_changed? && crash? && crash_start.nil?
  end

  def enqueue_inventory_reduction_job
    ReduceInventoryJob.perform_later(self.id)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[batch_no brew_date company_id status target_release created_at updated_at]
  end
end
