class StoreController < ApplicationController
  def index
  	@products = Product.all #lists all the products
  	if session[:counter].nil?
	  	session[:counter] = 1 #if nil, assign 1 to counter session

    else
	  	session[:counter] += 1 #adds 1 to the session on every page load
	end
	@visits = session[:counter]
  end
end
