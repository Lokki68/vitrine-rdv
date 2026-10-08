class Admin::SessionsController < ApplicationController
  layout 'admin'

  def new; end

  def create
    admin = Admin.find_by(email: params[:email].to_s.strip.downcase)

    if admin&.authenticate(params[:password])
      reset_session
      session[:admin_id] = admin.id
      redirect_to admin_root_path, notice: 'Connecté'
    else
      flash.now[:alert] = "Identifiants invalides"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to admin_login_path, notice: 'Déconnecté'
  end
end
