class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_create :generate_invitation_token

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :invitable, :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  # Devise modules and other associations go here
  belongs_to :company, optional: true

  # Define roles using enum
  enum role: { bartender: 0, brewer: 1, manager: 2, admin: 3 }

  validates :email, presence: true, uniqueness: true

  def name
    "#{first_name} #{last_name}".strip
  end

  def accept_invitation!
    # Set the invitation accepted timestamp
    self.invitation_accepted_at = Time.current
    # Set the user password (this could be a temporary password from the invitation)
    self.password = generate_password # Generate or provide a password input field to update it
    self.password_confirmation = self.password # Make sure the password matches
    save!
  end

  private

  def generate_invitation_token
    self.invitation_token = SecureRandom.hex(10)
  end
  def generate_password
    # You can generate a random password or prompt the user to enter one
    SecureRandom.hex(8)
  end
end
