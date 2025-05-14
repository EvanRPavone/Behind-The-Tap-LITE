class Invitation < ApplicationRecord
  before_create :generate_token, :set_expiration

  validates :email, presence: true
  validates :role, presence: true

  def expired?
    expires_at < Time.current
  end

  private

  def generate_token
    self.token = SecureRandom.hex(10)
  end

  def set_expiration
    self.expires_at = 7.days.from_now
  end
end
