module Admin
  class DashboardController < BaseController
    def index
      @next_appointments = Appointment.confirmed.where('starts_at > ?', Time.current).order(:starts_at).limit(5).includes(:service) || []

      @upcomming_count = @next_appointments.count
      @pending_count = Appointment.pending_payment.where("expires_at > ?", Time.current).count
      @published_posts_count= BlogPost.published.count
      @draft_posts_count = BlogPost.draft.count
    end
  end
end
