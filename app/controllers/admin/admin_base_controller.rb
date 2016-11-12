class Admin::AdminBaseController < ApplicationController
    before_action :set_locale


    private

    def set_locale
        I18n.locale = session[:locale].present? ? session[:locale] : :en
    end
end