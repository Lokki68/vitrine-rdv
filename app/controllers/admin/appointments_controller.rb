module Admin
  class AppointmentsController < BaseController
    before_action :set_appointment, only: %i[show cancel]

    def index
      @status = params[:status].presence_in(Appointment.aasm.states.map { _1.name.to_s })
      scope = Appointment.includes(:service).order(starts_at: :desc)
      scope = scope.where(status: @status) if @status
      @appointments = scope
    end

    def show; end

    def cancel
      if @appointment.may_cancel?
        @apointment.cancel!
        redirect_to admin_appointment_path(@appointment), notice: "Rendez-vous annulé."
      else
        redirect_to admin_appointment_path(@appointment), alert: "Annulation impossible."
      end
    end

    private

    def set_appointment = @appointment = Appointment.find(params[:id])
  end
end
