class Admin::ServicesController < Admin::BaseController
  before_action :set_service, only: %i[edit update destroy]

  def index
    @services = Service.order(:position, :name)
  end

  def new
    @service = Service.new
    @service.position = Service.all.length
  end

  def create
    @service = Service.new(service_params)

    if @service.save
      redirect_to admin_services_path, notice: "Préstation créé."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @service.update(service_params)
      redirect_to admin_service_path(@service), notice: "Prestation mise à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @service.destroy
      redirect_to admin_services_path, notice: "Prestation supprimée"
    else
      redirect_to admin_services_path, alert: @service.errors.full_messages.to_sentence
    end
  end

  private

  def set_service
    @service = Service.find_by(slug: params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :description, :kind, :duration_minutes, :price_euros, :deposit_euros, :active, :position)
  end
end
