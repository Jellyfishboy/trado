class Admin::DeliveryServicePricesController < Admin::AdminBaseController
  before_action :authenticate_user!
  layout "admin"

  def index
    @delivery_service = DeliveryService.includes(:active_prices).find(params[:delivery_service_id])
    @delivery_service_prices = @delivery_service.active_prices
  end


  def new
    set_delivery_service
    @delivery_service_price = @delivery_service.prices.build
  end

  def edit
    @form_delivery_service_price = DeliveryServicePrice.find(params[:id])
  end

  def create
    set_delivery_service
    @delivery_service_price = @delivery_service.prices.build(params[:delivery_service_price])
    
    if @delivery_service_price.save
      flash_message :success, t('controllers.admin.delivery_service_prices.create.valid')
      redirect_to admin_delivery_service_delivery_service_prices_url
    else
      render :new
    end
  end

  # Updating a delivery_service_price
  #
  # If the accessory is not associated with orders, update the current record.
  # Else create a new delivery_service_price with the new attributes.
  # Then set the old delivery_service_price as inactive.
  def update
    set_delivery_service_price
    unless @delivery_service_price.orders.empty?
      Store.inactivate!(@delivery_service_price)
      @old_delivery_service_price = @delivery_service_price
      @delivery_service_price = @old_delivery_service_price.delivery_service.prices.new
    end
    @delivery_service_price.attributes = params[:delivery_service_price]

    if @delivery_service_price.save
      flash_message :success, t('controllers.admin.delivery_service_prices.update.valid')
      redirect_to admin_delivery_service_delivery_service_prices_url
    else
      @form_delivery_service_price = @old_delivery_service_price ||= DeliveryServicePrice.find(params[:id])
      Store.activate!(@form_delivery_service_price)
      @form_delivery_service_price.attributes = params[:delivery_service_price]
      render :edit
    end
  end

  # Destroying a delivery_service_price
  #
  # If no associated order records, destroy the delivery_service_price. Else set it to inactive.
  def destroy
    set_delivery_service_price
    if @delivery_service_price.orders.empty?
      @result = Store.last_record(@delivery_service_price, DeliveryServicePrice.active.load.count)
    else
      Store.inactivate!(@delivery_service_price)
    end
    @result = [:success, t('controllers.admin.delivery_service_prices.destroy.valid')] if @result.nil?
    flash_message @result[0], @result[1]
    redirect_to admin_delivery_service_delivery_service_prices_url
  end

  private

  def set_delivery_service_price
    @delivery_service_price = DeliveryServicePrice.find(params[:id])
  end

  def set_delivery_service
    @delivery_service = DeliveryService.find(params[:delivery_service_id])
  end
end
