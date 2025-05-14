class YeastAndKnockoutLog < ApplicationRecord
  belongs_to :brew
  belongs_to :user
  belongs_to :yeast, class_name: 'Ingredient', optional: true
end
