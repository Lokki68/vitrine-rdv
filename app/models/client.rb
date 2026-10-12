class Client < ApplicationRecord
  has_many :appointments, dependent: :restrict_with_error

  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: { case_sensitive: false }, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { email.present? }

  before_validation { self.email = email.presence&.strip&.downcase }

  def full_name = "#{first_name} #{last_name}".strip
end
