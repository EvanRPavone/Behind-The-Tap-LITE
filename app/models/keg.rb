class Keg < ApplicationRecord
  belongs_to :recipe
  belongs_to :brew, optional: true # Brew can remain optional in case the keg doesn't always tie to a specific brew
  belongs_to :company
  # has_many :keg_shares, dependent: :destroy
  has_many :keg_shares, dependent: :destroy
  has_many :shared_companies, through: :keg_shares, source: :company
  belongs_to :shared_from_company, class_name: 'Company', foreign_key: 'shared_from', optional: true
  # Set default values before creation
  before_create :set_defaults

  validates :size, numericality: { greater_than: 0 }

  def display_size
    if size_unit.present?
      "#{size} #{size_unit.pluralize(size)}"
    else
      "#{size} gallons" # Default to gallons if size_unit is not set
    end
  end

  private

  def set_defaults
    self.status ||= 'available'
    self.name ||= "#{size.to_s}-gallon Keg"
    self.size_unit ||= 'gallons'
  end

end
