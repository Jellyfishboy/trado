class ApplicationController < ActionController::Base
    include ApplicationHelper
    before_action :authenticate_user!, :set_tracking_code
    before_action :set_cache_buster
    helper_method :current_cart
    helper_method :theme_presenter

    protected
    
    def set_cache_buster
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end

    def theme_presenter
      ThemePresenter.new(theme: Store::settings.theme)
    end

    def set_tracking_code
      gon.trackingCode = Store::settings.ga_code
    end

  	def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
  		cart = Cart.new 
      cart.save(validate: false)
  		session[:cart_id] = cart.id
  		return cart
  	end

    def after_sign_out_path_for resource_or_scope
        admin_root_path
    end
end
