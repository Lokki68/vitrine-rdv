class SlotFinderService
  Slot = Struct.new(:starts_at, :ends_at, keyword_init: true)

  def initialize(service:, date:, busy_periods: [])
    @service = service
    @date = date
    @busy_periods = busy_periods
    @settings = BookingSetting.current
    @zone = ActiveSupport::TimeZone[@settings.time_zone]
  end

  def call
    return [] if out_of_booking_window? || time_off?

    candidate_slots.reject { |slot| conflicts(slot) }
  end

  private

  def candidate_slots
    Availability.for_weekday(@date.wday).flat_map do |availability|
      window_start = @zone.local(@date.year, @date.month, @date.day, availability.start_time.hour, availability.start_time.min)
      window_end = @zone.local(@date.year, @date.month, @date.day, availability.end_time.hour, availability.end_time.min)

      slots_between(window_start, window_end)
    end
  end

  def slots_between(window_start, window_end)
    slots = []
    cursor = window_start
    duration = @service.duration_minutes.minutes

    while cursor + duration <= window_end
      slots << Slot.new(starts_at: cursor, ends_at: cursor + duration)
      cursor += @settings.slot_interval_minutes.minutes
    end

    slots
  end

  def conflicts?(slot)
    return true if slot.starts_at < earliest_bookable

    buffer = @settings.buffer_minutes.minutes
    from = slot.starts_at - buffer
    to = slot.ends_at + buffer

    existing_appointments.any? { |appointment| appointment.starts_at < to && appointment.ends_at > from } || @busy_periods.any? { |(b_start, b_end)| b_start < to && b_end > from }
  end

  def existing_appointments
    @existing_appointments ||= Appointment.blocking.overlapping(@date.beginning_of_day, @date.end_of_day + 1.day).to_a
  end

  def earliest_bookable
    @settings.min_notice_hours.hours.from_now
  end

  def out_of_booking_window?
    @date < Date.current || @date > @settings.max_advance_days.days.from_now.to_date
  end

  def time_off?
    TimeOff.covering(@date).exists?
  end
end