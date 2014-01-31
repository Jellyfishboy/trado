class ProductsController < ApplicationController

  skip_before_filter :authenticate_user!
  
  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    @cart_item = CartItem.new
    @cart_item_accessory = @cart_item.build_cart_item_accessory unless @product.accessories.empty?
    @notification = Notification.new
    @skus = @product.skus.active.order('cast(attribute_value as unsigned) asc')
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  def update_sku
    render :partial => 'products/update_sku', :format => [:js], :locals => { :sku_id => params[:sku_id], :accessory_id => params[:accessory_id] } 
  end

  def update_accessory
    render :partial => 'products/update_accessory', :format => [:js], :locals => { :accessory_id => params[:accessory_id], :sku_id => params[:sku_id] }
  end

end
