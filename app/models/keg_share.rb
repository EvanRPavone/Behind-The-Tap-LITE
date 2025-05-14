class KegShare < ApplicationRecord
  belongs_to :keg
  belongs_to :company

  validates :keg, presence: true
  validates :company, presence: true
end
