class Step < ApplicationRecord
  has_many :brews
  validates :name, presence: true
end

