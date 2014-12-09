class Admin::DeliveryServicesController < ApplicationController

  before_action :set_delivery_service, only: [:edit, :update, :destroy]
  before_action :get_associations, except: [:index, :destroy, :copy_countries, :set_countries]
  before_action :authenticate_user!
  layout "admin"

  def index
    @delivery_services = DeliveryService.active.load
  end

  def new
    @delivery_service = DeliveryService.new
  end

  def edit
    @form_delivery_service = DeliveryService.find(params[:id])
  end

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
        # @old_delivery_service.destinations.pluck(:zone_id).map { |z| Destination.create(:zone_id => z, :delivery_service_id => @delivery_service.id) }
        @old_delivery_service.prices.active.each do |price|
          new_price = price.dup
          new_price.delivery_service_id = @delivery_service.id
          new_price.save(validate: false)
        end
        Store::inactivate_all!(@old_delivery_service.prices)
        @old_delivery_service.prices.map { |p| p.destroy if p.orders.empty? }
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

  def copy_countries
    @delivery_services = params[:id].nil? ? DeliveryService.active.load : DeliveryService.where('id != ?', params[:id]).active.load
    render partial: 'admin/delivery_services/countries/copy', format: [:js]
  end

  def set_countries
    @delivery_service = DeliveryService.includes(:countries).find(params[:delivery_service_id])
    render partial: 'admin/delivery_services/countries/set', format: [:js]
  end

  private

  def set_delivery_service
    @delivery_service = DeliveryService.find(params[:id])
  end

  def get_associations
    @countries = Country.all
  end
end
