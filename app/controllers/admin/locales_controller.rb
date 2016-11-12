class Admin::LocalesController < ApplicationController
    def change
        set_locale
        set_locale_session
        redirect_to :back
    end

    private

    def set_locale
        @locale = params[:locale].to_sym
    end

    def set_locale_session
        session[:locale] = @locale if I18n.available_locales.include?(@locale)
    end
end