module Admin
  class AvailabilitiesController < BaseController
    before_action :set_availability, only: %i[edit update destroy]

    def index
      @availabilities = Availability.by_weekday
    end

    def new
      @availability = Availability.new(active: true)
    end

    def create
      @availability = Availability.new(availability_params)
      if @availability.save
        redirect_to admin_availabilities_path, notice: 'Plage ajoutée.'
      else
        render  :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @availability.update(availability_params)
        redirect_to admin_availabilities_path, notice: 'Plage mise à jour.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @availability.destroy
      redirect_to admin_availabilities_path, notice: 'Plage supprimée.', status: :see_other
    end

    private

    def set_availability = @availability = Availability.find(params[:id])

    def availability_params
      params.require(:availability).permit(:weekday, :start_time, :end_time)
    end
  end
end
