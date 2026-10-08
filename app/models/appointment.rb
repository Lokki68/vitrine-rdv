# app/models/appointment.rb
class Appointment < ApplicationRecord
  include AASM

  PENDING_TTL = 30.minutes

  belongs_to :service

  aasm column: :status, whiny_persistence: true do
    state :pending_payment, initial: true
    state :confirmed
    state :completed
    state :cancelled
    state :expired

    event :pay do
      transitions from: :pending_payment, to: :confirmed,
                  after: :stamp_paid_at,
                  after_commit: :after_confirmation
    end

    event :expire do
      transitions from: :pending_payment, to: :expired
    end

    event :cancel do
      transitions from: %i[pending_payment confirmed], to: :cancelled,
                  after: :stamp_cancelled_at,
                  after_commit: :after_cancellation
    end

    event :complete do
      transitions from: :confirmed, to: :completed,
                  guard: :started?
    end
  end

  validates :client_name, :client_email, :starts_at, presence: true
  validates :client_email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :slot_must_be_free, on: :create

  before_validation :set_end_time, on: :create
  before_validation :set_expiration, on: :create
  has_secure_token :cancellation_token

  # Créneaux qui bloquent l'agenda
  scope :blocking, -> {
    where(status: "confirmed")
      .or(where(status: "pending_payment").where("expires_at > ?", Time.current))
  }
  scope :upcoming, -> { where("starts_at > ?", Time.current).order(:starts_at) }
  scope :stale_pending, -> { where(status: "pending_payment").where("expires_at <= ?", Time.current) }

  private

  def started?
    starts_at <= Time.current
  end

  def stamp_paid_at
    self.paid_at = Time.current
  end

  def stamp_cancelled_at
    self.cancelled_at = Time.current
  end

  def after_confirmation
    GoogleCalendar::CreateEventJob.perform_later(id)
    AppointmentMailer.confirmation(self).deliver_later
    AdminMailer.new_appointment(self).deliver_later
  end

  def after_cancellation
    GoogleCalendar::DeleteEventJob.perform_later(google_event_id) if google_event_id.present?
    AppointmentMailer.cancellation(self).deliver_later
  end

  def set_end_time
    self.ends_at ||= starts_at + service.duration_minutes.minutes if starts_at && service
  end

  def set_expiration
    self.expires_at ||= PENDING_TTL.from_now
  end

  def slot_must_be_free
    return unless starts_at && ends_at

    overlap = Appointment.blocking.where("starts_at < ? AND ends_at > ?", ends_at, starts_at)
    errors.add(:starts_at, "n'est plus disponible") if overlap.exists?
  end
end