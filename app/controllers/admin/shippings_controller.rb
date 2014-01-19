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
    @shipping = Shipping.find(params[:id])
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

  # PUT /shippings/1
  # PUT /shippings/1.json
  def update
    @shipping = Shipping.find(params[:id])

    # If there are orders associated with the shipping, create a new shipping record
    @shipping = Shipping.new(params[:shipping]) unless @shipping.orders.empty?

    respond_to do |format|
      if @shipping.update_attributes(params[:shipping])

        @old_shipping = Shipping.find(params[:id])
        unless @old_shipping.orders.empty?
          # Plucks tier associations from old record and creates new associations for the newly updated record
          @old_shipping.tiereds.pluck(:tier_id).map { |t| Tiered.create(:tier_id => t, :shipping_id => @shipping.id) }
          # Deactivate the old shipping
          @old_shipping.inactivate!
        end

        format.html { redirect_to admin_shippings_url, notice: 'Shipping was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shipping.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shippings/1
  # DELETE /shippings/1.json
  def destroy
    @shipping = Shipping.find(params[:id])

    # If no associated records, destroy the shipping. Else set it to inactive
    @shipping.orders.empty? ? @shipping.destroy : @shipping.update_column(:active, false)

    respond_to do |format|
      format.html { redirect_to admin_shippings_url }
      format.json { head :no_content }
    end
  end
end
