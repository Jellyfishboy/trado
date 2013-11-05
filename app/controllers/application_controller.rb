class ApplicationController < ActionController::Base

    before_filter :authenticate_user!
    before_filter :category_list

    rescue_from CanCan::AccessDenied do |exception|
        flash[:error] = exception.message
        puts exception.message
        redirect_to store_url
    end

    private 

  	def current_cart
  		cart = Cart.create #creates a new cart
  		session[:cart_id] = cart.id #assigns the new session with the new cart id
  		cart #initializes the cart
  	end

    def category_list 
      @categories = Category.all
    end

    def after_sign_out_path_for(resource_or_scope)
        root_path
    end
end
