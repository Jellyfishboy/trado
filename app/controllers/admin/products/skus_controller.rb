class Admin::Products::SkusController < ApplicationController
  layout 'admin'
  
  def index
    @skus = Sku.active.all
  end

  def edit
    @sku = Sku.find(params[:id])
  end

  def update
    @sku = Sku.find(params[:id])
    binding.pry
    respond_to do |format|
      if @sku.update_attributes(params[:sku])
        format.html { redirect_to admin_products_skus_url, notice: 'SKU was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sku.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def destroy
    @sku = Sku.find(params[:id])
    respond_to do |format|
      # If sku count is less than 2 for the associated product, avoid delete or soft delete
      if @sku.product.skus.active.count > 1
        # If no associated orders or carts, delete
        if @sku.carts.empty? && @sku.orders.empty?
          @sku.destroy
        # If associated orders but no carts, just inactivate the sku
        elsif @sku.carts.empty? && !@sku.orders.empty?
          @sku.inactivate!
        # If orders and/or carts, inactivate sku and remove from cart items
        else
          @sku.inactivate!
          CartItem.where('sku_id = ?', @sku.id).destroy_all
        end
        flash[:success] = "SKU was successfully deleted."
        format.js { render :partial => "admin/skus/destroy", :format => [:js] }
        format.html { redirect_to admin_products_skus_url }
      else
        flash[:error] = "SKU failed to be removed from the database (you must have at least one SKU per product)."
        format.js
        format.html { redirect_to admin_products_skus_url }
      end
    end
  end
end
