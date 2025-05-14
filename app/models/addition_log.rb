class AdditionLog < ApplicationRecord
  belongs_to :brew
  belongs_to :user

  # Setting up associations for hop additions

  belongs_to :hop_addition_1, class_name: 'Ingredient', foreign_key: 'hop_addition_1_id', optional: true
  belongs_to :hop_addition_2, class_name: 'Ingredient', foreign_key: 'hop_addition_2_id', optional: true

  # Validation to ensure only hops are selected
  validate :only_allow_hops

  private

  def only_allow_hops
    errors.add(:hop_addition_1, "must be a hop") if hop_addition_1.present? && hop_addition_1.category != 'Hops'
    errors.add(:hop_addition_2, "must be a hop") if hop_addition_2.present? && hop_addition_2.category != 'Hops'
  end
end
