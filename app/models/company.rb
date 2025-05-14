class Company < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Relationships
  has_many :users
  has_many :recipes
  has_many :vessels
  has_many :brews
  has_many :ingredients
  has_many :kegs
  has_many :keg_shares, dependent: :destroy
  has_many :shared_kegs, through: :keg_shares, source: :keg

  # Partnerships (self-referential many-to-many)
  has_many :partnerships, dependent: :destroy
  has_many :partners, through: :partnerships, source: :partner

  has_many :inverse_partnerships, class_name: 'Partnership', foreign_key: :partner_id, dependent: :destroy
  has_many :inverse_partners, through: :inverse_partnerships, source: :company

  # Combine direct and inverse partnerships
  def all_partners
    (partners + inverse_partners).uniq
  end

  # Friendly ID
  def should_generate_new_friendly_id?
    name_changed? || slug.blank?
  end

  # Method to get all admin users for the company
  def admins
    users.where(role: :admin)
  end
end
