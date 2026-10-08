class TimeOff < ApplicationRecord
  validates :starts_on, :ends_on, presence: true
  validate :range_valid

  scope :covering, ->(date) { where("starts_on <= ? AND ends_on >= ?", date, date) }

  private

  def range_valid
    return if starts_on.blank? || ends_on.blank?
    errors.add(:ends_on, "doit être après le début") if ends_on < starts_on
  end
end
