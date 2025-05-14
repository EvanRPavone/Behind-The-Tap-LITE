class Vessel < ApplicationRecord
  belongs_to :company
  validates :name, presence: true
  validates :size_bbl, numericality: { greater_than: 0 }
  has_many :brews, dependent: :destroy
end
