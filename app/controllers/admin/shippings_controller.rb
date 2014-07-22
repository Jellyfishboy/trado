class Admin::ShippingsController < ApplicationController

  before_action :set_shipping, only: [:update, :destroy]
  before_action :get_associations, except: [:index, :destroy, :set_shipping]
  before_action :authenticate_user!
  layout "admin"

  def index
    @shippings = Shipping.active.includes(:zones, :tiers).load

    respond_to do |format|
      format.html
      format.json { render json: @shippings }
    end
  end


  def new
    @shipping = Shipping.new

    respond_to do |format|
      format.html
      format.json { render json: @shipping }
    end
  end

  def edit
    @form_shipping = Shipping.find(params[:id])
  end

  def create
    @shipping = Shipping.new(params[:shipping])
    
    respond_to do |format|
      if @shipping.save
        flash_message :success, 'Shipping was successfully created.'
        format.html { redirect_to admin_shippings_url }
      else
        format.html { render action: "new" }
        format.json { render json: @shipping.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updating a shipping
  #
  # If the accessory is not associated with orders, update the current record.
  # Else create a new shipping with the new attributes.
  # Pluck tier associations and create new associations for the new shipping record.
  # Then set the old shipping as inactive.
  def update
    unless @shipping.orders.empty?
      Store::inactivate!(@shipping)
      @shipping = Shipping.new(params[:shipping])
      @old_shipping = Shipping.find(params[:id])
    end

    if @shipping.update(params[:shipping])
      if @old_shipping
        @old_shipping.tiereds.pluck(:tier_id).map { |t| Tiered.create(:tier_id => t, :shipping_id => @shipping.id) }
        Store::inactivate!(@old_shipping)
      end
      flash_message :success, 'Shipping was successfully updated.'
      redirect_to admin_shippings_url
    else
      @form_shipping = Shipping.find(params[:id])
      Store::activate!(@form_shipping)
      @form_shipping.attributes = params[:shipping]
      render action: "edit"
    end
  end

  # Destroying a shipping
  #
  # If no associated order records, destroy the shipping. Else set it to inactive.
  def destroy
    if @shipping.orders.empty?
      @result = Store::last_record(@shipping, Shipping.active.load.count)
    else
      Store::inactivate!(@shipping)
    end
    @result = [:success, 'Shipping was successfully deleted.'] if @result.nil?
    flash_message @result[0], @result[1]
    redirect_to admin_shippings_url
  end

  private

    def set_shipping
      @shipping = Shipping.find(params[:id])
    end

    def get_associations
      @zones = Zone.all
    end
end
