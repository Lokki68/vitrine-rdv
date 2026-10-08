# app/models/booking_setting.rb
class BookingSetting < ApplicationRecord
  validates :slot_interval_minutes, :min_notice_hours, :max_advance_days,
            numericality: { greater_than: 0 }
  validates :buffer_minutes, numericality: { greater_than_or_equal_to: 0 }
  validates :time_zone, inclusion: { in: ActiveSupport::TimeZone.all.map { |z| z.tzinfo.name } }

  def self.current
    first_or_create!
  end
end