class AppointmentCreatorService
  Result = Struct.new(:appointment, :success?, :error, keyword_init: true)

  def initialize(service:, starts_at:, client_params:)
    @service = service
    @starts_at = starts_at
    @client_params = client_params
  end

  def call
    appointment = nil

    Appointment.transaction do
      release_expired_pending!

      appointment = @service.appointments.build(
        @client_params.merge(starts_at: @starts_at, status: :pending_payment)
      )

      appointment.save!
    end

    Result.new(appointment: appointment, success?: true)
  rescue ActiveRecord::StatementInvalid => e
    raise unless e.cause.is_a?(PG::ExclusionViolation)
    Result.new(success?: false, error: "Ce créneau vient d'être réservé, merci d'en choisir un autre.")
  rescue ActiveRecord::RecordInvalid => e
    Result.new(appointment: e.record, success?: false, error: e.message)
  end

  private

  def release_expired_pending!
    Appointment.pending_payment.where("expires_at <= ?", Time.current).update_all(status: Appointment.statuses[:expired])
  end
end