class Availability < ApplicationRecord
  WEEKDAYS = %w[Dimanche Lundi Mardi Mercredi Jeudi Vendredi Samedi].freeze
  
  validates :weekday, inclusion: { in: 0..6 }
  validates :start_time, :end_time, presence: true
  validate :end_after_start

  scope :active, -> { where(active: true) }
  scope :by_weekday, -> { order(:weekday, :start_time) }
  scope :for_weekday, ->(wday) { where(weekday: wday).order(:start_time) }
  
  def weekday_name = WEEKDAYS[weekday]

  private

  def end_after_start
    return if start_time.blank? || end_time.blank?
    errors.add(:end_time, "doit être après le début") if end_time <= start_time
  end
end
