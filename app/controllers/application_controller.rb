class ApplicationController < ActionController::Base

    before_filter :authenticate_user!
    helper_method :current_cart, :category_list, :current_tax_rate

    rescue_from CanCan::AccessDenied do |exception|
        flash[:error] = exception.message
        puts exception.message
        redirect_to store_url
    end

    protected

    def current_tax_rate
      country = session[:iso].nil? ? Country.where('iso = ?', 'EN').first : Country.where('iso = ?', session[:iso]).first
      country.tax ? country.tax.rate/100 : 0.2
    end

  	def current_cart
      Cart.find(session[:cart_id]) #searches for cart in session
    rescue ActiveRecord::RecordNotFound #starts an exception clause if no cart is found in sessions
  		cart = Cart.create #creates a new cart
  		session[:cart_id] = cart.id #assigns the new session with the new cart id
  		cart #initializes the cart
  	end

    def category_list
      Category.where('visible = ?', true).joins(:products).group("category_id HAVING count(products.id) > 0")
    end

    def after_sign_out_path_for(resource_or_scope)
        admin_root_path
    end
end
