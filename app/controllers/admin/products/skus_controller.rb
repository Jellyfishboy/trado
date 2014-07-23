class Admin::Products::SkusController < ApplicationController

  before_action :set_sku, except: :edit
  before_action :authenticate_user!

  def edit
    @form_sku = Sku.find(params[:id])
    render :partial => 'admin/products/skus/edit', :format => [:js]
  end

  # Updating a SKU
  #
  # If the SKU is not associated with orders, update the current record.
  # Else create a new SKU with the new attributes with the id of the parent product.
  # Set the old SKU as inactive. (It is now archived for reference by previous orders).
  # Delete any cart items associated with the old sku.
  def update
    unless @sku.orders.empty?
      Store::inactivate!(@sku)
      @old_sku = @sku
      @sku = Sku.new(params[:sku])
      @sku.product_id = @old_sku.product.id
    end

    respond_to do |format|
      if @sku.update(params[:sku])
        CartItem.where('sku_id = ?', @old_sku.id).destroy_all if @old_sku
        format.js { render :partial => 'admin/products/skus/success', :format => [:js] }
      else
        @form_sku = @old_sku ||= Sku.find(params[:id])
        Store::activate!(@form_sku)
        @form_sku.attributes = params[:sku]
        format.json { render :json => { :errors => @sku.errors.full_messages}, :status => 422 }
      end
    end
  end

  # Destroying a SKU
  #
  def destroy  
    if @sku.product.skus.active.count > 1
      @sku.orders.empty? ? @sku.destroy : Store::inactivate!(@sku)
      CartItem.where('sku_id = ?', @sku.id).destroy_all unless @sku.carts.empty?
      render :partial => "admin/products/skus/destroy", :format => [:js]
    else
      render :partial => 'admin/products/skus/failed_destroy',:format => [:js]
    end
  end

  private

    def set_sku
      @sku = Sku.find(params[:id])
    end
end
