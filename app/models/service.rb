class Service < ApplicationRecord
  extends FriendlyId
  friendly_id :name, use: :slugged

  has_many :appointments, dependent: :restrict_with_error

  validates :name, presence: true
  validates :duration_minutes, numericality: { greater_than: 0 }
  validates :price_cents, :deposit_cents, numericality: { greater_than_or_equal_to: 0 }
  validate :deposit_not_above_price

  scope :active, -> { where(active: true).order(:position) }

  def price = price_cents / 100.0
  def deposit = deposit_cents / 100.0

  private

  def deposit_not_above_price
    errors.add(:deposit_cents, "doit être inférieur ou égal au prix") if deposit_cents > price_cents
  end
end
