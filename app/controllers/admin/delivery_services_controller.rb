class Admin::DeliveryServicesController < ApplicationController
  before_action :set_delivery_service, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  layout "admin"

  # GET /delivery_services
  def index
    @delivery_services = DeliveryService.includes(:prices).load
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
    @delivery_service = DeliveryService.new(params[:delivery_service])

    if @delivery_service.save
      flash_message :success, 'Delivery service was successfully created.'
      redirect_to admin_delivery_services_url
    else
      render :new
    end
  end

  # PATCH/PUT /delivery_services/1
  def update
    if @delivery_service.update(params[:delivery_service])
      flash_message :success, 'Delivery service was successfully updated.'
      redirect_to admin_delivery_services_url
    else
      render :edit
    end
  end

  # DELETE /delivery_services/1
  def destroy
    @delivery_service.destroy
    flash_message :success, 'Delivery service was successfully destroyed.'
    redirect_to admin_delivery_services_url 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery_service
      @delivery_service = DeliveryService.find(params[:id])
    end
end
