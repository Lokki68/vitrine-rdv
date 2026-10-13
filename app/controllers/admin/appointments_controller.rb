module Admin
  class AppointmentsController < BaseController
    before_action :set_appointment, only: %i[show edit update destroy simulate_payment simulate_expiration cancel]
    before_action :load_form_data, only: %i[new edit]

    def index
      @appointments = Appointment.includes(:service, :client).order(starts_at: :desc)
      @appointments = @appointments.where(status: params[:status]) if params[:status].present?
    end

    def show; end

    def new
      @appointment = Appointment.new(client_id: params[:client_id])
    end

    def create
      @appointment = Appointment.new(appointment_params)
      prepare_manual_appointment(@appointment)

      if @appointment.save
        redirect_to admin_appointment_path(@appointment), notice: "Rendez-vous créé."
      else
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::StatementInvalid => e
      raise unless e.case.is_a?(PG::ExclusionViolation)
      @appointment.errors.add(:starts_at, "Chevauche un autre rendez-vous actif")
      render :new, status: :unprocessable_entity
    end

    def edit; end

    def update
      @appointment.assign_attributes(appointment_params)
      recompute_end(@appointment)

      if @appointment.save
        redirect_to admin_appointment_path(@appointment), notice: 'Rendez-vous mis à jour.'
      else
        render :edit, status: :unprocessable_entity
      end
    rescue ActiveRecord::StatementInvalid => e
      raise unless e.cause.is_a?(PG::ExclusionViolation)
      @appointment.errors.add(:starts_at, "chevauche un autre rendez-vous actif")
      render :edit, status: :unprocessable_entity
    end

    def destroy
      @appointment.destroy
      redirect_to admin_appointments_path, notice: "Rendez-vous supprimé.", status: :see_other
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

    def simulate_expiration
      @appointment.update!(status: "expired", expires_at: Time.current)
      redirect_to admin_appointment_path(@appointment), notice: "Expiration simulée : créneau libéré"
    end

    private

    def load_form_data
      @clients = Client.order(:first_name, :last_name)
      @services = Service.order(:name)
    end

    def set_appointment = @appointment = Appointment.find(params[:id])

    def appointment_params
      params.require(:appointment).permit(:client_id, :service_id, :starts_at, :client_notes, :status)
    end

    def prepare_manual_appointment(appointment)
      recompute_end(appointment)
      appointment.status = "confirmed"
      appointment.expires_at = nil
      appointment.cancellation_token = SecureRandom.urlsafe_base64(24)
    end

    def recompute_end(appointment)
      return unless appointment.starts_at && appointment.service
      appointment.ends_at = appointment.starts_at + appointment.service.duration_minutes.minutes
    end
  end
end
