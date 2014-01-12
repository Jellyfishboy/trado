class Admin::Products::SkusController < ApplicationController
  layout 'admin'
  
  def index
    @skus = Sku.all
    respond_to do |format|
      format.html
    end
  end
  
  def destroy
    @sku = Sku.find(params[:id])
    respond_to do |format|
      if @product.carts.empty? && @product.orders.empty?
        if @sku.destroy
          flash[:success] = "SKU was successfully deleted."
          format.js { render :partial => "admin/skus/destroy", :format => [:js] }
        else
          flash[:error] = "SKU failed to be removed from the database (you must have at least one SKU per product)."
        end
      else 
        format.html { redirect_to admin_products_skus_url, notice: 'You cannot edit a SKU which is associated with carts or orders.' }
      end
    end
  end
end
