class Service < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :appointments, dependent: :restrict_with_error

  validates :name, presence: true
  validates :duration_minutes, numericality: { greater_than: 0 }
  validates :price_cents, :deposit_cents, numericality: { greater_than_or_equal_to: 0 }
  validate :deposit_not_above_price

  scope :active, -> { where(active: true).order(:position) }

  def price_euros = price_cents / 100.0

  def price_euros=(value)
    self.price_cents = (value.to_s.tr(",", ".").to_f * 100).round
  end

  def deposit_euros = deposit_cents / 100.0

  def deposit_euros=(value)
    self.deposit_cents = (value.to_s.tr(",", ".").to_f * 100).round
  end

  private

  def deposit_not_above_price
    errors.add(:deposit_cents, "doit être inférieur ou égal au prix") if deposit_cents > price_cents
  end
end
