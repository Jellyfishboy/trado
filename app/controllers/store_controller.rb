class StoreController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
  	@products = Product.all #lists all the products
  	@cart = current_cart
  end
end
