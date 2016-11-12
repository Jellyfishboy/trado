class Admin::AdminBaseController < ApplicationController
    before_action :set_locale

    private

    def set_locale
        I18n.locale = Store.settings.locale
    end
end