class ApplicationController < ActionController::Base
    include ApplicationHelper
    before_action :authenticate_user!, :set_tracking_code, :set_tax_rate, :set_store_theme
    helper_method :current_cart
    helper_method :theme_presenter

    protected

    def theme_presenter
        ThemePresenter.new(theme: Store.settings.theme)
    end

    def set_tracking_code
        gon.trackingCode = Store.settings.ga_code
    end

    def set_tax_rate
        gon.taxRate = Store.settings.tax_rate
    end

    def set_store_theme
        gon.themeName  = Store.settings.theme_name
    end

  	def current_cart
        Cart.includes(:cart_items).find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
		cart = Cart.create
		session[:cart_id] = cart.id
		return cart
  	end

    def after_sign_out_path_for resource_or_scope
        admin_root_path
    end
end
