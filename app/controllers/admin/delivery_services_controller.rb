class Admin::DeliveryServicesController < Admin::AdminBaseController
  before_action :authenticate_user!
  layout "admin"

  def index
    set_all_countries
    @delivery_services = DeliveryService.active.includes(:active_prices).load
  end

  def new
    set_all_countries
    @delivery_service = DeliveryService.new
  end

  def edit
    set_delivery_service
    set_all_countries
    @form_delivery_service = DeliveryService.find(params[:id])
  end

  def create
    set_all_countries
    @delivery_service = DeliveryService.new(params[:delivery_service])

    if @delivery_service.save
      flash_message :success, t('controllers.admin.delivery_services.create.valid')
      redirect_to admin_delivery_services_url
    else
      render :new
    end
  end

  def update
    set_delivery_service
    set_all_countries
    unless @delivery_service.orders.empty?
      Store.inactivate!(@delivery_service)
      @old_delivery_service = @delivery_service
      @delivery_service = DeliveryService.new
    end
    @delivery_service.attributes = params[:delivery_service]

    if @delivery_service.save
      if @old_delivery_service
        @old_delivery_service.active_prices.each do |price|
          new_price = price.dup
          new_price.delivery_service_id = @delivery_service.id
          new_price.save(validate: false)
        end
        Store.inactivate_all!(@old_delivery_service.prices)
        @old_delivery_service.prices.map { |p| p.destroy if p.orders.empty? }
      end
      flash_message :success, t('controllers.admin.delivery_services.update.valid')
      redirect_to admin_delivery_services_url
    else
      @form_delivery_service = @old_delivery_service ||= DeliveryService.find(params[:id])
      Store.activate!(@form_delivery_service)
      @form_delivery_service.attributes = params[:delivery_service]
      render :edit
    end
  end

  def destroy
    set_delivery_service
    set_all_countries
    if @delivery_service.orders.empty?
      @result = Store.last_record(@delivery_service, DeliveryService.active.load.count)
    else
      Store.inactivate!(@delivery_service)
      Store.inactivate_all!(@delivery_service.prices)
    end
    @result = [:success, t('controllers.admin.delivery_services.destroy.valid')] if @result.nil?
    flash_message @result[0], @result[1]
    redirect_to admin_delivery_services_url
  end

  def copy_countries
    set_all_countries
    @delivery_services = params[:delivery_service_id].blank? ? DeliveryService.active.load : DeliveryService.where('id != ?', params[:delivery_service_id]).active.load
    render json: { modal: render_to_string(partial: 'admin/delivery_services/countries/modal', locals: { delivery_services: @delivery_services }) }, status: 200
  end

  def set_countries
    set_all_countries
    @delivery_service = DeliveryService.includes(:countries).find(params[:delivery_service_id])
    render json: { countries: @delivery_service.countries.map{ |c| c.id.to_s } }, status: 200
  rescue ActiveRecord::RecordNotFound
    render json: { errors: t('controllers.admin.delivery_services.set_countries.select_tag') }, status: 422
  end

  private

  def set_delivery_service
    @delivery_service = DeliveryService.find(params[:id])
  end

  def set_all_countries
    @countries = Country.all
  end
end
