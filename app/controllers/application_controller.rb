class ApplicationController < ActionController::Base
    include ApplicationHelper
    before_action :authenticate_user!, :set_tracking_code
    helper_method :current_cart
    helper_method :theme_presenter
    layout "../themes/#{Store::settings.theme_name}/layout/application"

    protected

    def theme_presenter
      @theme_presenter ||= ThemePresenter.new(theme: Store::settings.theme)
    end

    def set_tracking_code
      gon.trackingCode = Store::settings.ga_code
    end

  	def current_cart
      Cart.find(session[:cart_id]) #searches for cart in session
    rescue ActiveRecord::RecordNotFound #starts an exception clause if no cart is found in sessions
  		cart = Cart.create #creates a new cart
  		session[:cart_id] = cart.id #assigns the new session with the new cart id
  		cart # returns cart object
  	end

    def after_sign_out_path_for(resource_or_scope)
        admin_root_path
    end
end
