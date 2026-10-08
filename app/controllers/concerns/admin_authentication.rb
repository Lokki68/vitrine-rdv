module AdminAuthentication
  extends ActiveSuport::Concern

  included do
    before_action :require_admin
    helper_method :current_admin
  end

  private

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:amdin_id])
  end

  def require_admin
    redirect_to admin_login_path, alert: "Connexion requise" unless current_admin
  end
end