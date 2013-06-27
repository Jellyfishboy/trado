class ApplicationController < ActionController::Base

    before_filter :authenticate_user!

    rescue_from CanCan::AccessDenied do |exception|
        flash[:error] = exception.message
        redirect_to root_url
    end

    private 

  	def current_cart
  		Cart.find(session[:cart_id]) #searches for cart in session
  	rescue ActiveRecord::RecordNotFound #starts an exception clause if no cart is found in sessions
  		cart = Cart.create #creates a new cart
  		session[:cart_id] = cart.id #assigns the new session with the new cart id
  		cart #initializes the cart
  	end
end
