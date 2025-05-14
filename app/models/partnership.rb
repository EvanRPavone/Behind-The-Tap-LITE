class Partnership < ApplicationRecord
  belongs_to :company
  belongs_to :partner, class_name: 'Company'

  validates :company_id, uniqueness: { scope: :partner_id, message: "Partnership already exists." }
  validate :not_self

  after_create :create_reverse_partnership
  after_destroy :destroy_reverse_partnership

  private

  # Ensure a company can't partner with itself
  def not_self
    errors.add(:partner_id, "can't be the same as company") if company_id == partner_id
  end

  # Create the reciprocal partnership
  def create_reverse_partnership
    unless Partnership.exists?(company_id: partner_id, partner_id: company_id)
      Partnership.create!(company_id: partner_id, partner_id: company_id)
    end
  end

  # Destroy the reciprocal partnership
  def destroy_reverse_partnership
    reverse_partnership = Partnership.find_by(company_id: partner_id, partner_id: company_id)
    reverse_partnership&.destroy
  end
end
