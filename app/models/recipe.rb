class Recipe < ApplicationRecord
  belongs_to :company
  has_many :brews, foreign_key: 'in_tank', primary_key: 'name'
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :kegs, dependent: :destroy  # Connect kegs via brews

  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true

  validates :name, presence: true
  validates :target_abv, numericality: { greater_than_or_equal_to: 0 }

  def total_weight
    recipe_ingredients.sum(&:converted_amount)
  end

  def full_name
    "#{name} - #{size_bbl} BBL"
  end
end
