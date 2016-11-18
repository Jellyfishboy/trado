class Admin::AccessoriesController < Admin::AdminBaseController
  before_action :authenticate_user!
  layout 'admin'

  def index
    set_accessories
  end

  def new
    new_accessory
  end

  def edit
    @form_accessory = Accessory.find(params[:id])
  end

  def create
    @accessory = Accessory.new(params[:accessory])

    if @accessory.save
      flash_message :success, 'Accessory was successfully created.'
      redirect_to admin_accessories_url
    else
      render :new
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
      render :edit
    end
  end

  def destroy
    set_accessory
    Store.active_archive(CartItemAccessory, :accessory_id, @accessory)
    flash_message :success, 'Accessory was successfully deleted.'
    redirect_to admin_accessories_url
  end

  private

  def set_accessory
    @accessory ||= Accessory.find(params[:id])
  end

  def set_accessories
    @accessories ||= Accessory.where('active = ?', true)
  end

  def new_accessory
    @accessory = Accessory.new
  end
end
