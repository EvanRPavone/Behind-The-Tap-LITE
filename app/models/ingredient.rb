class Ingredient < ApplicationRecord
  belongs_to :company

  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients

  # Categories Constant for ingredients
  CATEGORIES = ['Malts (Grains)', 'Hops', 'Yeast', 'Puree', 'Other'].freeze
  # Unit Types Constant for Ingredients
  UNIT_TYPES = ['Bag', 'Barrel', 'Container', 'Packet', 'Box', 'Other'].freeze
  # Validations
  validates :name, presence: true
  validates :category, inclusion: { in: CATEGORIES, allow_nil: true }
  validates :type_of_unit, inclusion: { in: UNIT_TYPES, message: "%{value} is not a valid unit type" }, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :weight_per_unit, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :total_weight, numericality: { greater_than_or_equal_to: 0, allow_nil: true }


  after_save :update_total_weight

  # Scopes
  scope :sorted_by_category, -> {
    order(Arel.sql("CASE
                      WHEN category = 'Malts (Grains)' THEN 1
                      WHEN category = 'Hops' THEN 2
                      WHEN category = 'Yeast' THEN 3
                      WHEN category = 'Puree' THEN 4
                      WHEN category = 'Other' THEN 5
                      ELSE 6
                    END, category ASC"))
  }
  # Calculate total weight dynamically
  def calculate_total_weight
    (amount || 0) * (weight_per_unit || 0)
  end

  def display_name
    brand.present? ? "#{brand} #{name} (#{category})" : "#{name} (#{category})"
  end

  private

  def update_total_weight
    self.total_weight = (amount || 0) * (weight_per_unit || 0)
    save if changed? # Ensures it saves only if there are changes
  end

end
