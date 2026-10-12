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

    def new
      @appointment = Appointment.new(client_id: params[:client_id])
    end

    def create
      @appointment = Appointment.new(appointment_params)
      prepare_manual_appointment(@appointment)
    end

    def cancel
      if @appointment.may_cancel?
        @apointment.cancel!
        redirect_to admin_appointment_path(@appointment), notice: "Rendez-vous annulé."
      else
        redirect_to admin_appointment_path(@appointment), alert: "Annulation impossible."
      end
    end

    def simulate_payment
      @appointment.simulate_payment!
      redirect_to admin_appointment_path(@appointment), notice: "Paiement simulé : rendez-vous confirmé"
    end

    def simulation_expiration
      @appointment.update!(status: "expired", expires_at: Time.current)
      redirect_to admin_appointment_path(@appointment), notice: "Expiration simulée : créneau libéré"
    end

    private

    def set_appointment = @appointment = Appointment.find(params[:id])

    def appointment_params
      params = require(:appointment).permit(:client_id, :service_id, :starts_at, :client_notes, :status)
    end
  end
end
