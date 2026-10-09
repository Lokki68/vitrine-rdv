module Admin
  class PaymentsController < BaseController
    def index
      @pending = Appointment.pending_payment.includes(:service).order(:expires_at)
      @paid = Appointment.where.not(paid_at: nil).includes(:service).order(paid_at: :desc).limit(50)
    end
  end
end
