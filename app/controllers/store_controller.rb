class StoreController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
  	@products = Product.all #lists all the products
  	@cart = current_cart
  	if session[:counter].nil?
	  	session[:counter] = 1 #if nil, assign 1 to counter session

    else
	  	session[:counter] += 1 #adds 1 to the session on every page load
	end
	@visits = session[:counter]
  end
end
