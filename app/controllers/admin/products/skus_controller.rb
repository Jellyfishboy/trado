class Admin::Products::SkusController < ApplicationController
  layout 'admin'

  def edit
    @form_sku = Sku.find(params[:id])
    render :partial => '/admin/products/skus/edit', :format => [:js]
  end

  # Updating a SKU
  #
  # If the SKU is not associated with orders, update the current record.
  # Else create a new SKU with the new attributes with the id of the parent product.
  # Set the old SKU as inactive. (It is now archived for reference by previous orders).
  # Delete any cart items associated with the old sku.
  def update
    @sku = Sku.find(params[:id])
    unless @sku.orders.empty? || params[:sku][:stock]
      @sku.inactivate!
      @sku = Sku.new(params[:sku])
      @old_sku = Sku.find(params[:id])
      @sku.product_id = @old_sku.product.id
      extra_values = {:product_id => @old_sku.product.id, :stock => @old_sku.stock, :stock_warning_level => @old_sku.stock_warning_level}
      params[:sku].merge!(extra_values)
    end

    respond_to do |format|
      if @sku.update_attributes(params[:sku])
        if @old_sku
          @old_sku.inactivate!
          CartItem.where('sku_id = ?', @old_sku.id).destroy_all
        end
        format.js { render :partial => 'admin/products/skus/success', :format => [:js], :object => @sku }
      else
        @form_sku = Sku.find(params[:id])
        @form_sku.activate!
        @form_sku.attributes = params[:sku]
        format.json { render :json => { :errors => @sku.errors.full_messages}, :status => 422 }
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
