class Admin::Products::SkusController < ApplicationController
  layout 'admin'
  
  def index
    @skus = Sku.active.all
  end

  def edit
    @sku = Sku.find(params[:id])
  end


  # Updating a SKU
  #
  # If the SKU is not associated with orders, update the current record.
  # Else create a new SKU with the new attributes with the id of the parent product.
  # Set the old SKU as inactive. (It is now archived for reference by previous orders).
  # Delete any cart items associated with the old sku.
  def update
    @sku = Sku.find(params[:id])

    unless @sku.orders.empty?
      @sku = Sku.new(params[:sku])
      @old_sku = Sku.find(params[:id])
      @sku.product_id = @old_sku.product.id
    end

    respond_to do |format|
      if @sku.update_attributes(params[:sku])
        if @old_sku
          @old_sku.inactivate!
          CartItem.where('sku_id = ?', @old_sku.id).destroy_all
        end
        format.html { redirect_to admin_products_skus_url, notice: 'SKU was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sku.errors, status: :unprocessable_entity }
      end
    end
  end

  # Destroying a SKU
  #
  # Various if statements to handle how a SKU is dealt with then checking order and cart associations
  # If sku count is less than 2 for the associated product, avoid delete or soft delete.
  # If there are no carts or orders: destroy the sku.
  # If there are orders but no carts: deactivate the sku.
  # If there are carts but no orders: delete all cart items then delete the sku.
  # If there are orders and carts: deactivate the sku and delete all cart items.
  def destroy
    @sku = Sku.find(params[:id])

    respond_to do |format|      
      if @sku.product.skus.active.count > 1
        if @sku.carts.empty? && @sku.orders.empty?
          @sku.destroy        
        elsif @sku.carts.empty? && !@sku.orders.empty?
          @sku.inactivate!
        elsif !@sku.carts.empty? && @sku.orders.empty?
          CartItem.where('sku_id = ?', @sku.id).destroy_all
          @sku.destroy   
        else
          @sku.inactivate!
          CartItem.where('sku_id = ?', @sku.id).destroy_all
        end
        format.js { render :partial => "admin/products/skus/destroy", :format => [:js] }
        flash[:success] = "SKU was successfully deleted."
        format.html { redirect_to admin_products_skus_url }
      else
        format.js { render :partial => 'admin/products/skus/failed_destroy',:format => [:js] }
        flash[:error] = "SKU failed to be removed from the database (you must have at least one SKU per product)."
        format.html { redirect_to admin_products_skus_url }
      end
    end
  end
end
