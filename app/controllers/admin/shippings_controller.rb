class Admin::ShippingsController < ApplicationController
  layout "admin"
  # GET /shippings
  # GET /shippings.json
  def index
    @shippings = Shipping.active.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shippings }
    end
  end

  # GET /shippings/new
  # GET /shippings/new.json
  def new
    @shipping = Shipping.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shipping }
    end
  end

  # GET /shippings/1/edit
  def edit
    @form_shipping = Shipping.find(params[:id])
  end

  # POST /shippings
  # POST /shippings.json
  def create
    @shipping = Shipping.new(params[:shipping])
    
    respond_to do |format|
      if @shipping.save
        format.html { redirect_to admin_shippings_url, notice: 'Shipping was successfully created.' }
        format.json { render json: @shipping, status: :created, location: @shipping }
      else
        format.html { render action: "new" }
        format.json { render json: @shipping.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updating a shipping
  #
  # First grab the current shipping via the param id.
  # If the shipping has associated orders, create a new shipping with the new attributes.
  # Upon updating, retrieve the current record again via the param id.
  # If the current shipping has associated orders, pluck tier associations and create new associations for the new shipping record.
  # Then set the current shipping as inactive.
  def update
    @shipping = Shipping.find(params[:id])

    unless @shipping.orders.empty?
      @shipping.inactivate!
      @shipping = Shipping.new(params[:shipping])
      @old_shipping = Shipping.find(params[:id])
    end

    respond_to do |format|
      if @shipping.update_attributes(params[:shipping])

        if @old_shipping
          @old_shipping.tiereds.pluck(:tier_id).map { |t| Tiered.create(:tier_id => t, :shipping_id => @shipping.id) }
          @old_shipping.inactivate!
        end

        format.html { redirect_to admin_shippings_url, notice: 'Shipping was successfully updated.' }
        format.json { head :no_content }
      else
        @form_shipping = Shipping.find(params[:id])
        @form_shipping.activate!
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
    @shipping = Shipping.find(params[:id])

    @shipping.orders.empty? ? @shipping.destroy : @shipping.update_column(:active, false)

    respond_to do |format|
      format.html { redirect_to admin_shippings_url }
      format.json { head :no_content }
    end
  end
end
