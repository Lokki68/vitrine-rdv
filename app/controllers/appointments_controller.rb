class AppointmentsController < ApplicationController
  before_action :load_service, only: %i[new slots create]

  def new
    @service = Service.active
    @appointment = Appointment.new(service: @service)
  end

  def slots
    @date = Date.parse(params[:date])
    @slots = SlotFinderService.new(service: @service, date: @date, busy_period: GoogleCalendar::Freebusy.call(@date)).call

    render partial: "appointments/slots", locals: { slots: @slots, service: @service, date: @date }
  rescue Date::Error
    render :bad_request
  end

  def create
    @service = Service.where(active: true).find(appointment_params[:service_id])

    client = Client.find_or_initialize_by(email: appointment_params[:client_email].to_s.strip.downcase)
    client.first_name = appointment_params[:client_name].to_s.first if client.new_record?
    client.last_name  = appointment_params[:client_name].to_s.split[1..]&.join(" ").presence || "-" if client.new_record?
    client.phone      = appointment_params[:client_phone] if client.phone.blank?

    @appointment = Appointment.new(appointment_params.merge(service: @service, client: client))
    @appointment.ends_at = @appointment.starts_at + @service.duration_minutes.minutes if @appointment.starts_at
    @appointment.expires_at = 30.minutes.from_now
    @appointment.cancellation_token = SecureRandom.urlsafe_base64(24)

    if @appointment.save
      redirect_to appointment_path(@appointment, token: @appointment.cancellation_token)
    else
      render :new, status: :unprocessable_entity
    end

  rescue ActiveRecord::StatementInvalid => e
    raise unless e.cause.is_a?(PG::ExclusionViolation)
    @appointment.errors.add(:starts_at, "Vient d'être réservé par quelqu'un d'autre")
    render :new, status: :unprocessable_entity
  end

  def show
    @appointment = Appointment.find_by(id: params[:id], cancellation_token: params[:token])
  end

  private

  def load_service
    @service = Service.active.find(params[:service_id])
  end

  def client_params
    params.require(:appointment).permit(:name, :email, :phone)
  end

  def appointment_params
    params.require(:appointment).permit(:service_id, :starts_at, :client_name, :client_email, :client_phone, :client_notes)
  end
end
