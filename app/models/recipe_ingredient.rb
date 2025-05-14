class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  # Define allowed units of measurement
  UNIT_MEASUREMENTS = ['oz', 'lbs', 'grams', 'kg', 'gallons', 'bbl'].freeze

  validates :unit_of_measurement, inclusion: { in: UNIT_MEASUREMENTS, message: "%{value} is not a valid unit" }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  def converted_amount
    case unit_of_measurement
    when 'lbs' then amount
    when 'oz' then amount / 16.0
    when 'kg' then amount * 2.20462
    when 'grams' then amount * 0.00220462
    when 'gallons' then amount * 8.34
    when 'bbl' then amount * 31
    else amount
    end
  end
end
