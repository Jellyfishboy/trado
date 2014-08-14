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
    @form_delivery_service = DeliveryService.find(params[:id])
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

  def update
    unless @delivery_service.orders.empty?
      Store::inactivate!(@delivery_service)
      @old_delivery_service = @delivery_service
      @delivery_service = DeliveryService.new(params[:delivery_service])
    end

    if @delivery_service.update(params[:delivery_service])
      if @old_delivery_service
        @old_shipping.destinations.pluck(:zone_id).map { |z| Destination.create(:zone_id => z, :delivery_service_id => @delivery_service.id) }
      end
      flash_message :success, 'Delivery service was successfully updated.'
      redirect_to admin_delivery_services_url
    else
      @form_delivery_service = @old_delivery_service ||= DeliveryService.find(params[:id])
      Store::activate!(@form_delivery_service)
      @form_delivery_service.attributes = params[:delivery_service]
      render :edit
    end
  end

  def destroy
    if @delivery_service.orders.empty?
      @result = Store::last_record(@delivery_service, DeliveryService.active.load.count)
    else
      Store::inactivate!(@delivery_service)
    end
    @result = [:success, 'Delivery service was successfully deleted.'] if @result.nil?
    flash_message @result[0], @result[1]
    redirect_to admin_delivery_services_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery_service
      @delivery_service = DeliveryService.find(params[:id])
    end
end
