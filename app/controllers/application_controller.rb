class ApplicationController < ActionController::Base

    before_filter :authenticate_user!, :set_tracking_code
    helper_method :current_cart, :category_list

    rescue_from CanCan::AccessDenied do |exception|
        flash[:error] = exception.message
        puts exception.message
        redirect_to store_url
    end

    protected

    def set_tracking_code
      gon.trackingCode = Store::settings.ga_code
    end

  	def current_cart
      Cart.find(session[:cart_id]) #searches for cart in session
    rescue ActiveRecord::RecordNotFound #starts an exception clause if no cart is found in sessions
  		cart = Cart.create #creates a new cart
  		session[:cart_id] = cart.id #assigns the new session with the new cart id
  		cart #initializes the cart
  	end

    def category_list
      Category.where('visible = ?', true).joins(:products).group("category_id HAVING count(products.id) > 0").order('sorting ASC')
    end

    def after_sign_out_path_for(resource_or_scope)
        admin_root_path
    end
end
