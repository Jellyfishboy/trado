class Admin::DeliveryServicePricesController < ApplicationController

  before_action :set_delivery_service_price, only: [:update, :destroy]
  before_action :get_associations, except: [:index, :destroy, :set_delivery_service_price]
  before_action :authenticate_user!
  layout "admin"

  def index
    @delivery_service_prices = DeliveryServicePrice.active.load
  end


  def new
    @delivery_service_price = DeliveryServicePrice.new

    respond_to do |format|
      format.html
      format.json { render json: @delivery_service_price }
    end
  end

  def edit
    @form_delivery_service_price = DeliveryServicePrice.find(params[:id])
  end

  def create
    @delivery_service_price = DeliveryServicePrice.new(params[:delivery_service_price])
    
    respond_to do |format|
      if @delivery_service_price.save
        flash_message :success, 'Delivery service price was successfully created.'
        format.html { redirect_to admin_delivery_service_prices_url }
      else
        format.html { render action: "new" }
        format.json { render json: @delivery_service_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updating a delivery_service_price
  #
  # If the accessory is not associated with orders, update the current record.
  # Else create a new delivery_service_price with the new attributes.
  # Then set the old delivery_service_price as inactive.
  def update
    unless @delivery_service_price.orders.empty?
      Store::inactivate!(@delivery_service_price)
      @old_delivery_service_price = @delivery_service_price
      @delivery_service_price = DeliveryServicePrice.new(params[:delivery_service_price])
    end

    if @delivery_service_price.update(params[:delivery_service_price])
      if @old_delivery_service_price
        @old_delivery_service_price.destinations.pluck(:zone_id).map { |z| Destination.create(:zone_id => z, :delivery_service_price_id => @delivery_service_price.id) }
      end
      flash_message :success, 'DeliveryServicePrice was successfully updated.'
      redirect_to admin_delivery_service_prices_url
    else
      @form_delivery_service_price = @old_delivery_service_price ||= DeliveryServicePrice.find(params[:id])
      Store::activate!(@form_delivery_service_price)
      @form_delivery_service_price.attributes = params[:delivery_service_price]
      render action: "edit"
    end
  end

  # Destroying a delivery_service_price
  #
  # If no associated order records, destroy the delivery_service_price. Else set it to inactive.
  def destroy
    if @delivery_service_price.orders.empty?
      @result = Store::last_record(@delivery_service_price, DeliveryServicePrice.active.load.count)
    else
      Store::inactivate!(@delivery_service_price)
    end
    @result = [:success, 'DeliveryServicePrice was successfully deleted.'] if @result.nil?
    flash_message @result[0], @result[1]
    redirect_to admin_delivery_service_prices_url
  end

  private

    def set_delivery_service_price
      @delivery_service_price = DeliveryServicePrice.find(params[:id])
    end

    def get_associations
      @zones = Zone.all
    end
end
