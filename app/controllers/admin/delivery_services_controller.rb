class Admin::DeliveryServicesController < ApplicationController
  before_action :set_delivery_service, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  layout "admin"

  # GET /delivery_services
  def index
    @delivery_services = DeliveryService.all
  end

  # GET /delivery_services/1
  def show
  end

  # GET /delivery_services/new
  def new
    @delivery_service = DeliveryService.new
  end

  # GET /delivery_services/1/edit
  def edit
  end

  # POST /delivery_services
  def create
    @delivery_service = DeliveryService.new(delivery_service_params)

    if @delivery_service.save
      redirect_to @delivery_service, notice: 'Delivery service was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /delivery_services/1
  def update
    if @delivery_service.update(delivery_service_params)
      redirect_to @delivery_service, notice: 'Delivery service was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /delivery_services/1
  def destroy
    @delivery_service.destroy
    redirect_to delivery_services_url, notice: 'Delivery service was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery_service
      @delivery_service = DeliveryService.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def delivery_service_params
      params.require(:delivery_service).permit(:name, :description, :courier_name)
    end
end
