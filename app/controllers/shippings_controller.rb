class ShippingsController < ApplicationController
  # GET /shippings
  # GET /shippings.json
  def index
    @shippings = Shipping.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shippings }
    end
  end

  # GET /shippings/1
  # GET /shippings/1.json
  def show
    @shipping = Shipping.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shipping }
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
        format.html { redirect_to @shipping, notice: 'Shipping was successfully created.' }
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

    respond_to do |format|
      if @shipping.update_attributes(params[:shipping])
        format.html { redirect_to @shipping, notice: 'Shipping was successfully updated.' }
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
    @shipping.destroy

    respond_to do |format|
      format.html { redirect_to shippings_url }
      format.json { head :no_content }
    end
  end
end
