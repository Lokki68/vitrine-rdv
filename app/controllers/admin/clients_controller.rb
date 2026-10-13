class Admin::ClientsController < Admin::BaseController
  before_action :set_client, only: %i[show edit update destroy]

  def index
    @clients = Client.order(:last_name, :first_name)
    @clients = @clients.where("first_name ILIKE :q OR :LAST_NAME ILIKE :q OR email ILIKE :q", q: "%#{params[:q]}") if params[:q].present?
  end

  def show
    @appointments = @client.appointments.includes(:service).order(starts_at: :desc)
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to admin_client_path(@client), notice: "Client créé"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @client.update(client_params)
      redirect_to admin_client_path(@client), notice: "Client mis à jour"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @client.destroy
      redirect admin_clients_path,notice: "Client supprimé?", status: :see_other
    else
      redirect_to admin_client_path(@client), alert: @client.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:first_name, :last_name, :email, :phone, :notes)
  end
end
