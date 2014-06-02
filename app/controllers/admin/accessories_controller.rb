class Admin::AccessoriesController < ApplicationController
  
  before_filter :authenticate_user!
  layout 'admin'
  # GET /accessories
  # GET /accessories.json
  def index
    @accessories = Accessory.where('active = ?', true)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @accessories }
    end
  end

  # GET /accessories/new
  # GET /accessories/new.json
  def new
    @accessory = Accessory.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @accessory }
    end
  end

  # GET /accessories/1/edit
  def edit
    @form_accessory = Accessory.find(params[:id])
  end

  # POST /accessories
  # POST /accessories.json
  def create
    @accessory = Accessory.new(params[:accessory])

    respond_to do |format|
      if @accessory.save
        flash[:success] = 'Accessory was successfully created.'
        format.html { redirect_to admin_accessories_url }
        format.json { render json: @accessory, status: :created, location: @accessory }
      else
        format.html { render action: "new" }
        format.json { render json: @accessory.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updating an accessory
  #
  # If the accessory is not associated with orders, update the current record.
  # Else create a new accessory with the new attributes.
  # Pluck product associations and create new associations for the new accesory record.
  # Set the old accessory as inactive. (It is now archived for reference by previous orders).
  # Delete any cart item accessories associated with the old accessory.
  def update
    @accessory = Accessory.find(params[:id])
    unless @accessory.orders.empty?
      Store::inactivate!(@accessory)
      @accessory = Accessory.new(params[:accessory])
      @old_accessory = Accessory.find(params[:id])
    end

    respond_to do |format|
      if @accessory.update_attributes(params[:accessory])

        if @old_accessory
          @old_accessory.accessorisations.pluck(:product_id).map { |t| Accessorisation.create(:product_id => t, :accessory_id => @accessory.id) }
          Store::inactivate!(@old_accessory)
          CartItemAccessory.where('accessory_id = ?', @old_accessory.id).destroy_all
        end
        flash[:success] = 'Accessory was successfully updated.'
        format.html { redirect_to admin_accessories_url }
        format.json { head :no_content }
      else
        @form_accessory = Accessory.find(params[:id])
        Store::activate!(@form_accessory)
        @form_accessory.attributes = params[:accessory]
        format.html { render action: "edit" }
        format.json { render json: @accessory.errors, status: :unprocessable_entity }
      end
    end
  end

  # Destroying an accessory
  #
  # Various if statements to handle how a Accessory is dealt with then checking order and cart associations
  # If there are no carts or orders: destroy the accessory.
  # If there are orders but no carts: deactivate the accessory.
  # If there are carts but no orders: delete all cart item accessories then delete the accessory.
  # If there are orders and carts: deactivate the accessory and delete all cart item accessories.
  def destroy
    @accessory = Accessory.find(params[:id])
    
    if @accessory.carts.empty? && @accessory.orders.empty?
      @accessory.destroy        
    elsif @accessory.carts.empty? && !@accessory.orders.empty?
      Store::inactivate!(@accessory)
    elsif !@accessory.carts.empty? && @accessory.orders.empty?
      CartItemAccessory.where('accessory_id = ?', @accessory.id).destroy_all
      @accessory.destroy   
    else
      Store::inactivate!(@accessory)
      CartItemAccessory.where('accessory_id = ?', @accessory.id).destroy_all
    end
      
    respond_to do |format|
      flash[:success] =  'Accessory was successfully deleted.'
      format.html { redirect_to admin_accessories_url }
      format.json { head :no_content }
    end
  end
end
