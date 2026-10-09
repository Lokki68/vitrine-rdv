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
    result = AppointmentCreatorService.new(
      service: @service,
      start_at: Time.zone.parse(params.require(:appointment)[:starts_at]),
      client_params: client_params
    ).call

    if result.success?
      session_url = StripeCheckoutCreator.new(result.appointment, success_url: confirmation_appointments_url, cancel_url: new_appointment_url(service_id: @service.id)).call
      redirect_to session_url, allow_other_host: true, status: :see_other
    else
      @appointment = result.appoitment || Appointment.new(service: @service)
      flash.now[:alert] = result.error
      render :new, status: :unprocessable_entity
    end
  end

  def confirmation; end

  private

  def load_service
    @service = Service.active.find(params[:service_id])
  end

  def client_params
    params.require(:appointment).permit(:name, :email, :phone)
  end
end
