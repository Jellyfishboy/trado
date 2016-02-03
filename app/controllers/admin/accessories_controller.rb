class Admin::AccessoriesController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    @accessories = Accessory.where('active = ?', true)

    respond_to do |format|
      format.html
      format.json { render json: @accessories }
    end
  end

  def new
    @accessory = Accessory.new
    respond_to do |format|
      format.html
      format.json { render json: @accessory }
    end
  end

  def edit
    @form_accessory = Accessory.find(params[:id])
  end

  def create
    @accessory = Accessory.new(params[:accessory])

    respond_to do |format|
      if @accessory.save
        flash_message :success, 'Accessory was successfully created.'
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
    set_accessory
    unless @accessory.orders.empty?
      Store.inactivate!(@accessory)
      @old_accessory = @accessory
      @accessory = Accessory.new(params[:accessory])
    end

    if @accessory.update(params[:accessory])
      if @old_accessory
        @old_accessory.accessorisations.pluck(:product_id).map { |t| Accessorisation.create(:product_id => t, :accessory_id => @accessory.id) }
        CartItemAccessory.where('accessory_id = ?', @old_accessory.id).destroy_all
      end
      flash_message :success, 'Accessory was successfully updated.'
      redirect_to admin_accessories_url
    else
      @form_accessory = @old_accessory ||= Accessory.find(params[:id])
      Store.activate!(@form_accessory)
      @form_accessory.attributes = params[:accessory]
      render action: "edit"
    end
  end

  # Destroying an accessory
  #
  def destroy
    set_accessory
    Store.active_archive(CartItemAccessory, :accessory_id, @accessory)
    flash_message :success, 'Accessory was successfully deleted.'
    redirect_to admin_accessories_url
  end

  private

  def set_accessory
    @accessory = Accessory.find(params[:id])
  end
end
