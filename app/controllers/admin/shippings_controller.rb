class Admin::ShippingsController < ApplicationController

  before_filter :set_shipping, only: [:update, :destroy]
  before_filter :authenticate_user!
  layout "admin"

  def index
    @shippings = Shipping.active.includes(:zones, :tiers).all

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
        format.json { render json: @shipping, status: :created, location: @shipping }
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

    respond_to do |format|
      if @shipping.update_attributes(params[:shipping])

        if @old_shipping
          @old_shipping.tiereds.pluck(:tier_id).map { |t| Tiered.create(:tier_id => t, :shipping_id => @shipping.id) }
          Store::inactivate!(@old_shipping)
        end
        flash_message :success, 'Shipping was successfully updated.'
        format.html { redirect_to admin_shippings_url }
        format.json { head :no_content }
      else
        @form_shipping = Shipping.find(params[:id])
        Store::activate!(@form_shipping)
        @form_shipping.attributes = params[:shipping]
        format.html { render action: "edit" }
        format.json { render json: @shipping.errors, status: :unprocessable_entity }
      end
    end
  end

  # Destroying a shipping
  #
  # If no associated order records, destroy the shipping. Else set it to inactive.
  def destroy

    if @shipping.orders.empty?
      @result = Store::last_record(@shipping, Shipping.active.all.count)
    else
      Store::inactivate!(@shipping)
    end

    respond_to do |format|
      if @result.nil?
        flash_message :success, 'Shipping was successfully deleted.'
      else
        flash_message @result[0], @result[1]
      end
      format.html { redirect_to admin_shippings_url }
      format.json { head :no_content }
    end
  end

  private

    def set_shipping
      @shipping = Shipping.find(params[:id])
    end
end
